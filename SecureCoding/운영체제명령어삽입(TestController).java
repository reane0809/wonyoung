//운영체제 명령어 삽입 방지 코드
// ~ line 172
//Command 인젝션
	@RequestMapping(value="/test/command_test.do", method = RequestMethod.POST)
	@ResponseBody
	public String testCommandInjection(HttpServletRequest request, HttpSession session){
		StringBuffer buffer=new StringBuffer();	
		String data=request.getParameter("data");
		
		String[] allowCommand= {"type", "dir"};           //inject
		
		int index=TestUtil.getInt(data);
		
		if(index < 0 || index > 1) {
			buffer.append("잘못된 요청입니다."); 
			return buffer.toString();
		} else {
			data=allowCommand[index];
		}                                               // to here
			  
	    if ( data != null  && data.equals("type")) {
	    		data=data+" "+
	    	            request.getSession().getServletContext().getRealPath("/")+
	    	            "file1.txt"; 
	    		System.out.println(data);
	    }
    	
		Process process;
		String osName = System.getProperty("os.name");
		String[] cmd;

		if(osName.toLowerCase().startsWith("window")) {
		    cmd = new String[] { "cmd.exe","/c",data };
		    for( String s : cmd)
		       System.out.print(s+" ");
		} else {
		    cmd = new String[] { "/bin/sh",data };
		}

		try {
			process = Runtime.getRuntime().exec(cmd);
			InputStream in = process.getInputStream(); 
			Scanner s = new Scanner(in,"EUC-KR");
			buffer.append("실행결과: <br/>");
			while(s.hasNextLine() == true) {
			    buffer.append(s.nextLine()+"<br/>");
			}
		} catch (IOException e) {
			// TODO Auto-generated catch block
			buffer.append("실행오류발생");
			e.printStackTrace();
		} 
			return buffer.toString();

	}
