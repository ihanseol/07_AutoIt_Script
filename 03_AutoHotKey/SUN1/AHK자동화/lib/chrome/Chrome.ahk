class Chrome
{
	static DebugPort := 9222
	; 명령줄 매개변수에 적합한 방식으로 문자열을 이스케이프합니다.
	CliEscape(Param)	{
		return """" RegExReplace(Param, "(\\*)""", "$1$1\""") """"
	}
	
	/*
		디버그 모드에서 크롬의 인스턴스와 실행 중인 포트를 찾습니다. 
		켜짐. 인스턴스가 발견되지 않으면 false 값을 반환합니다. 
		하나 이상의 경우 인스턴스가 발견되면 키가 있는 연관 배열을 반환합니다.
		포트 및 값은 시작하는 데 사용되는 전체 명령줄 텍스트입니다.
		이것이 사용되는 방법의 한 가지 예는 사용하려는 포트에서 chrome 인스턴스가 이미 열려 있는 경우 다른 포트에서 chrome을 여는 것입니다.
		
		;원하는 포트를 가져오면 가장 큰 포트에 하나를 더한 포트를 사용합니다.
		DebugPort := 9222
		if (Chromes := Chrome.FindInstances()).HasKey(DebugPort)
			DebugPort := Chromes.MaxIndex() + 1
		ChromeInst := new Chrome(ProfilePath,,,, DebugPort)
		
		;또 다른 용도는 실행 중인 인스턴스를 스캔하고 새 인스턴스를 시작하는 대신 하나에 연결하는 것입니다.
		if (Chromes := Chrome.FindInstances())
			ChromeInst := {"base": Chrome, "DebugPort": Chromes.MinIndex()}
		else
			ChromeInst := new Chrome(ProfilePath)
	*/
	FindInstances() {
		static Needle := "--remote-debugging-port=(\d+)"
		Out := {}
		for Item in ComObjGet("winmgmts:")
			.ExecQuery("SELECT CommandLine FROM Win32_Process"
			. " WHERE Name = 'chrome.exe'")
			if RegExMatch(Item.CommandLine, Needle, Match)
				Out[Match1] := Item.CommandLine
		return Out.MaxIndex() ? Out : False
	}
	
	/*
		ProfilePath    - 사용할 사용자 프로필 디렉터리의 경로. 공백이면 표준을 사용합니다.
		URLs             - Chrome이 열릴 때 로드할 페이지 또는 페이지 배열
		Flags             - 시작할 때 크롬에 대한 추가 플래그
		ChromePath - chrome.exe에 대한 경로, 공백이면 시작 메뉴에서 감지합니다.
		DebugPort   - Chrome의 원격 디버깅 서버가 실행되어야 하는 포트
	*/
	__New(ProfilePath:="", URLs:="about:blank", Flags:="", ChromePath:="", DebugPort:="")
	{
		; Verify ProfilePath
		if (ProfilePath != "" && !InStr(FileExist(ProfilePath), "D"))
			throw Exception("The given ProfilePath does not exist")
		this.ProfilePath := ProfilePath
		
		; Verify ChromePath
		if (ChromePath == "")
			FileGetShortcut, %A_StartMenuCommon%\Programs\Google Chrome.lnk, ChromePath
		if (ChromePath == "")
			RegRead, ChromePath, HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows\CurrentVersion\App Paths\chrome.exe
		if !FileExist(ChromePath)
			throw Exception("Chrome could not be found")
		this.ChromePath := ChromePath
		
		; Verify DebugPort
		if (DebugPort != "")
		{
			if DebugPort is not integer
				throw Exception("DebugPort must be a positive integer")
			else if (DebugPort <= 0)
				throw Exception("DebugPort must be a positive integer")
			this.DebugPort := DebugPort
		}
		
		; Escape the URL(s)
		for Index, URL in IsObject(URLs) ? URLs : [URLs]
			URLString .= " " this.CliEscape(URL)
		
		Run, % this.CliEscape(ChromePath)
		. " --remote-debugging-port=" this.DebugPort
		. (ProfilePath ? " --user-data-dir=" . this.CliEscape(A_ScriptDir . "\" . ProfilePath) : "")
		. (Flags ? " " Flags : "")
		. URLString
		,,, OutputVarPID
		
		this.PID := OutputVarPID
	}
	
	Kill()	{  ; 프로세스 종료하여 Chrome을 종료합니다.
		Process, Close, % this.PID
	}
	
	/*
		디버그 인터페이스를 노출하는 페이지 목록에 대해 크롬을 쿼리합니다.
		여기에는 표준 탭 외에도 확장 구성 페이지와 같은 페이지가 포함됩니다.
	*/
	GetPageList() {
		http := ComObjCreate("WinHttp.WinHttpRequest.5.1")
		http.open("GET", "http://127.0.0.1:" this.DebugPort "/json")
		http.send()
		return this.Jxon_Load(http.responseText)
	}
	
	/*
		제공된 기준과 일치하는 페이지의 디버그 인터페이스에 대한 연결을 반환합니다. 
		여러 페이지가 기준과 일치하는 경우 페이지를 열었던 날짜순으로 표시됩니다.
		Key            - 검색할 페이지 목록의 키(예: "url" 또는 "title")
		Value         - 제공된 키에서 검색할 값
		MatchMode - "exact", "contains", "startswith" 또는 "regex"와 같이 사용할 검색 종류
		Index         - 여러 페이지가 주어진 기준과 일치하는 경우 그 중 어떤 페이지를 반환할지
		fnCallback - 페이지에서 메시지가 수신될 때마다 호출되는 함수
	*/
	GetPageBy(Key, Value, MatchMode:="exact", Index:=1, fnCallback:="", fnClose:="") {
		Count := 0
		for n, PageData in this.GetPageList() {
			if (((MatchMode = "exact" && PageData[Key] = Value) ; Case insensitive
			|| (MatchMode = "contains" && InStr(PageData[Key], Value))
			|| (MatchMode = "startswith" && InStr(PageData[Key], Value) == 1)
			|| (MatchMode = "regex" && PageData[Key] ~= Value))
			&& ++Count == Index)
				return new this.Page(PageData.webSocketDebuggerUrl, fnCallback, fnClose)
		}
	}
	
	GetPageByURL(Value, MatchMode:="startswith", Index:=1, fnCallback:="", fnClose:="")	{
		return this.GetPageBy("url", Value, MatchMode, Index, fnCallback, fnClose)
	}
	
	GetPageByTitle(Value, MatchMode:="startswith", Index:=1, fnCallback:="", fnClose:="")	{
		return this.GetPageBy("title", Value, MatchMode, Index, fnCallback, fnClose)
	}
	
	; 검색할 기본 유형은 일반 Chrome 탭의 표시 영역인 "페이지"입니다.
	GetPage(Index:=1, Type:="page", fnCallback:="", fnClose:="")	{
		return this.GetPageBy("type", Type, "exact", Index, fnCallback, fnClose)
	}
	
	; WebSocket URL이 지정된 페이지의 디버그 인터페이스에 연결합니다.
	class Page
	{
		Connected := False
		ID := 0
		Responses := []
		; wsurl         - 원하는 페이지의 WebSocket URL
		; fnCallback - 메시지가 수신될 때마다 호출되는 함수
		; fnClose     - 페이지 연결이 끊길 때마다 호출되는 함수
		__New(wsurl, fnCallback:="", fnClose:="") {
			this.fnCallback := fnCallback
			this.fnClose := fnClose
			this.BoundKeepAlive := this.Call.Bind(this, "Browser.getVersion",, False)
			if IsObject(wsurl) 	; TODO: 유효하지 않은 개체에 예외 발생
				wsurl := wsurl.webSocketDebuggerUrl
			wsurl := StrReplace(wsurl, "localhost", "127.0.0.1")
			this.ws := {"base": this.WebSocket, "_Event": this.Event, "Parent": this}
			this.ws.__New(wsurl)
			while !this.Connected
				Sleep, 50
		}
		
		/*
			지정된 엔드포인트를 호출하고 지정된 매개변수를 제공합니다
			DomainAndMethod - 호출하려는 끝점의 끝점 도메인 및 메서드 이름입니다. 예)
				PageInst.Call("Browser.close")
				PageInst.Call("Schema.getDomains")
			
			Params - 끝점에 제공할 매개변수의 연관 배열입니다. 예를 들어:
				PageInst.Call("Page.printToPDF", {"scale": 0.5 ; Numeric Value
					, "landscape": Chrome.Jxon_True() ; Boolean Value
					, "pageRanges: "1-5, 8, 11-13"}) ; String value
				PageInst.Call("Page.navigate", {"url": "https://autohotkey.com/"})
			
			WaitForResponse - 반환 값을 받는 데 필요한 Chrome에서 응답을 받을 때까지 차단할지 
			                               또는 응답을 기다리지 않고 스크립트를 계속할지 여부입니다.
		*/
		Call(DomainAndMethod, Params:="", WaitForResponse:=True)	{
			if !this.Connected
				throw Exception("Not connected to tab")
			; 응답을 받기 전에 더 많은 호출이 발생할 경우 ID에 임시 변수를 사용합니다.
			ID := this.ID += 1
			this.ws.Send(Chrome.Jxon_Dump({"id": ID
			, "params": Params ? Params : {}
			, "method": DomainAndMethod}))

			if !WaitForResponse
				return
			this.responses[ID] := False  ; Wait for the response
			while !this.responses[ID]
				Sleep, 50
			response := this.responses.Delete(ID)  ; Get the response, check if it's an error
			if (response.error)
				throw Exception("Chrome indicated error in response",, Chrome.Jxon_Dump(response.error))
			return response.result
		}
		
		/*
			페이지에서 일부 JavaScript 실행. 예를 들어:
			PageInst.Evaluate("alert(""I can't believe it's not IE!"");")
			PageInst.Evaluate("document.getElementsByTagName('button')[0].click();")
		*/
		Evaluate(JS)	{
			response := this.Call("Runtime.evaluate",
			( LTrim Join
			{
				"expression": JS,
				"objectGroup": "console",
				"includeCommandLineAPI": Chrome.Jxon_True(),
				"silent": Chrome.Jxon_False(),
				"returnByValue": Chrome.Jxon_False(),
				"userGesture": Chrome.Jxon_True(),
				"awaitPromise": Chrome.Jxon_False()
			}
			))
			
			if (response.exceptionDetails)
				throw Exception(response.result.description, -1
					, Chrome.Jxon_Dump({"Code": JS
					, "exceptionDetails": response.exceptionDetails}))
			
			return response.result
		}
		
		/*
			페이지의 readyState가 DesiredState와 일치할 때까지 기다립니다.			
			DesiredState - 페이지의 ReadyState가 일치하기를 기다리는 상태
			Interval         - 얼마나 자주 상태가 일치하는지 확인해야 합니다.
		*/
		WaitForLoad(DesiredState:="complete", Interval:=100)	{
			while this.Evaluate("document.readyState").value != DesiredState
				Sleep, Interval
		}
		
		; 스크립트가 페이지에 연결된 WebSocket에서 메시지를 수신할 때 트리거되는 내부 함수입니다.
		Event(EventName, Event){	; WebSocket에서 호출된 경우 클래스 컨텍스트를 조정합니다.
			if this.Parent
				this := this.Parent
			; TODO: Handle Error events
			if (EventName == "Open") {
				this.Connected := True
				BoundKeepAlive := this.BoundKeepAlive
				SetTimer, %BoundKeepAlive%, 15000
			}
			else if (EventName == "Message") {
				data := Chrome.Jxon_Load(Event.data)
				
				; Run the callback routine
				fnCallback := this.fnCallback
				if (newData := %fnCallback%(data))
					data := newData
				if this.responses.HasKey(data.ID)
					this.responses[data.ID] := data
			}
			else if (EventName == "Close") {
				this.Disconnect()
				fnClose := this.fnClose
				%fnClose%(this)
			}
		}
		
		/*
			페이지의 디버그 인터페이스에서 연결을 끊으면 인스턴스가 가비지 수집될 수 있습니다.
			이 메서드는 페이지 작업 마쳤을 때 항상 호출해야 함. 그렇지 않으면 스크립트에서 메모리 누수됨.
		*/
		Disconnect() {
			if !this.Connected
				return
			this.Connected := False
			this.ws.Delete("Parent")
			this.ws.Disconnect()
			BoundKeepAlive := this.BoundKeepAlive
			SetTimer, %BoundKeepAlive%, Delete
			this.Delete("BoundKeepAlive")
		}
		#Include %A_LineFile%\..\lib\WebSocket.ahk\WebSocket.ahk
	}
	#Include %A_LineFile%\..\lib\AutoHotkey-JSON\Jxon.ahk
}
