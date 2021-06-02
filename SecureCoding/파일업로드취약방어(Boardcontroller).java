	//line 238~
//added by 32154240
	@RequestMapping("/get_image.do")
	public void getImage(HttpServletRequest request, HttpSession session, HttpServletResponse response) {
		int idx=TestUtil.getInt(request.getParameter("idx"));
		//읽어본 게시물인지 확인
		if( session.getAttribute("idx") == null ||
				(Integer)session.getAttribute("idx") != idx ) {
			return;
		}
		//저장된 파일명을 읽어오는 작업이 필요
		BoardModel board = service.getOneArticle(idx);
		
		String filePath=session.getServletContext().getRealPath("/")+
								  "WEB-INF/files/"+board.getSavedFileName();
		System.out.println("filename: " +filePath);
		
		BufferedOutputStream out=null;
		InputStream in=null;
		try {
			response.setContentType("image/jpeg");
			response.setHeader("Content-Disposition", "inline;filename="+board.getFileName());
			File file=new File(filePath);

			in=new FileInputStream(file);
			out=new BufferedOutputStream(response.getOutputStream());
			int len;
			byte[] buf=new byte[1024];
			while( (len=in.read(buf)) > 0) {
			out.write(buf,0,len);
			}
			
		}catch(Exception e) {
			e.printStackTrace();
			System.out.println("파일 전송 에러");
		} finally {
			if ( out != null) try { out.close(); }catch(Exception e) {}
			if ( in != null) try { in.close(); }catch(Exception e) {}
		}
	}
	
	
	@RequestMapping(value="/write.do", method=RequestMethod.POST)
	public String boardWriteProc(@ModelAttribute("BoardModel") BoardModel boardModel, MultipartHttpServletRequest request, HttpSession session){
		// get upload file 
		String uploadPath = session.getServletContext().getRealPath("/")
											+"WEB-INF/files/";
		System.out.println("uploadPath: "+uploadPath);
		MultipartFile file = request.getFile("file");
		 // 업로드 되는 파일 사이즈 제한
		if ( file != null && ! "".equals(file.getOriginalFilename())
				&& file.getSize() < 5120000 && file.getContentType().contains("image")) {
			//업로드 파일명
			String fileName = file.getOriginalFilename();
			if( fileName.toLowerCase().endsWith(".jpg")) {
				//저장할 파일명을 랜덤하게 생성해 사용한다.
			String savedFileName = UUID.randomUUID().toString();
			File uploadFile = new File(uploadPath+ savedFileName); 
			try {
				file.transferTo(uploadFile);
			} catch (Exception e) {
				System.out.println("upload error");
			}
			boardModel.setFileName(fileName);
			boardModel.setSavedFileName(savedFileName);
			}
		}
		String content =  boardModel.getContent().replaceAll("\r\n", "<br />");		
		boardModel.setContent(content);
		service.writeArticle(boardModel);		
		return "redirect:list.do";
	}
