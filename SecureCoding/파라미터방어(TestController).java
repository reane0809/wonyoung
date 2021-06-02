	//line 570 
//....
// 새로운 고객 정보 등록
	 }else if ( "edit".equals(action) && "admin".equals(session.getAttribute("userId"))) {
	    if( id != null && ! "".equals(id)) {
	        m=new MemberModel(0,id,id,name,"","");
	        int result=service.addMember(m);       
	        if ( result == 3) {
	        	 m=service.findMember(id);
	        	 if ( m != null) {    
	        		 session.setAttribute("member", m);
			         buffer.append(m.getUserId()+" 사용자 등록을 완료하였습니다.<br/>");   
				     buffer.append("사용자ID: "+m.getUserId()+"<br/>");
				     buffer.append("고객명: "+m.getUserName()+"<br/>");
				     buffer.append("전화번호: "+m.getPinNo()+"<br/>");
				     buffer.append("가입일자: "+m.getJoinDate()+"<br/>"); 
	        	 } else {
	        		 buffer.append("사용자 등록 실패: "+result);
	        	 }
	        } else {
		        buffer.append("사용자 등록 실패: "+result);
	        }
	    }else {
	         buffer.append("userId가 입력되지 않았습니다.");
	    }
	 }	
	 return buffer.toString();
	}

//.....
//.....
