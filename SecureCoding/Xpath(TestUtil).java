	public String XPathFilter(String input)
	{
		return input.replaceAll("[',\\[]", "");
	}
	
	public String readXML(String name)  {             //input

	 StringBuffer buffer=new StringBuffer();          // here
     
	 try {
	   InputStream is =
			   this.getClass().getClassLoader().getResourceAsStream("config/address.xml");
       DocumentBuilderFactory builderFactory = 
    		    DocumentBuilderFactory.newInstance();
	   DocumentBuilder builder =  builderFactory.newDocumentBuilder();
	   Document xmlDocument = builder.parse(is);
	   XPath xPath =  XPathFactory.newInstance().newXPath();
	 
	   System.out.println("ccard 출력");                                                    //secure code
	   //String expression = "/addresses/address[@name='"+name+"']/ccard";
	   String expression = "/addresses/address[@name='"+XPathFilter(name)+"']/ccard";       //secure code
