<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8" import="java.util.*,java.io.*"%>
<!DOCTYPE html PUBLIC "-//W3C//DTD HTML 4.01 Transitional//EN" "http://www.w3.org/TR/html4/loose.dtd">
<html>
<head>
<meta http-equiv="Content-Type" content="text/html; charset=UTF-8">
<title>Insert title here</title>
</head>
<body>
<!-- State the functions here -->
<%! 
static String formatted=""; 

public int getSuperScript(String text,int i){
	formatted+="<sup>";
	//int index = text.substring(i).indexOf(";");
	//String operator = text.substring(i,index+1);
	i++;
	if(text.charAt(i)=='('){
		i++;
		while(text.charAt(i)!=')'&&i<text.length()){
			formatted+=text.charAt(i);
			i++;
		}
		i++;
	}else{
		formatted+=text.charAt(i);
		i++;
	}
	formatted+="</sup></math><math xmlns='http://www.w3.org/1998/Math/MathML'>";
	return i;
}

//Must Find a better method to determine the position of the bracket ). I have simply parsed back ^200 5spaces.
public int getNumerator(int i){
	int start;
	int brackets = 0;
	System.out.print("The value of length: "+i+"charAt(i-6) : "+formatted.charAt(i-6)+" and the string is "+formatted.substring(i-10,i));
	if(formatted.charAt(i-6)!=')'){
		start = i-6;
	}else{
		i-=7;
		brackets = 1;
		/*while(formatted.charAt(i) != '(')
				i--;*/
		while(brackets!=0&&i>=0){
			if(formatted.charAt(i)==')'||formatted.charAt(i)=='(')
				brackets = (formatted.charAt(i) == ')')?brackets+1:brackets-1;
			if(brackets == 0)
				break;
			i--;
		}
		start = i;
	}
	System.out.print("The value of start: "+start);
	return start;
}
%>

<!-- State the entire code here -->
<% 
//Text to be parsed
String text = (String)session.getAttribute("usertext") ;
//System.out.println("The text is : "+text);
//Final Html Code Generated

//all modes to be stated here such as <munderover>
int munderover=0,division=0,power=0,text_mode=0;

//List of all the variables specific to modes . this is for munderover
//String up_lim,lw_lim;
//int brackets=0;

//Creating a map to keep track of the brackets of power and Division(Add any other element whose brackets are to be tracked and create the corresponding code)
//Creating a stack of functions which require bracket tracking
HashMap<String,Integer> map = new HashMap<String,Integer>();
ArrayList<String> stack = new ArrayList<String>();
map.put("division",0);
map.put("power",0);
		
//List of all the operations without unicodes
String[] op = {"&alpha;","&pi;","&infin;","&pm;","&mp;","&hbar;","&exist;","&forall;",
"&iff;","&Rightarrow;","&ne;","&ap;","&sim;","&cong;","&propto;","&wedgeq;","&lt;","&leq;","&ll;","&gt;",
"&geq;","&gg;","&middot;","&times;","&compfn;","&div;","&setminus;","&oplus;","&cap;","&cup;","&subset;",
"&supset;","&isin;","&notin;","&wedge;","&vee;","&not;","&rightarrow;","&mapsto;","&angsph;"};

//List of all opeartions using unicodes which qualify super and subscripts such as sigma
Integer[] uni={8721,8719,8747,67,80};
//List of all The Symbols
String[] sym = {"&emptyset;","&naturals;","&integers;","&rationals;","&reals;","&complexes;","&Theta;"};

//List of ALl the Vectors
String v[] = {"&rharu;","&rarr;","&tilde;","_"};

List<String> operators = Arrays.asList(op);
List<String> vectors = Arrays.asList(v);
List<String> symbols = Arrays.asList(sym);
List<Integer> unicodes = Arrays.asList(uni);
int i;
// How to make File Name unique
File f= new File("input.txt");
f.createNewFile();
FileWriter fw=new FileWriter(f);
BufferedWriter bw = new BufferedWriter(fw);
bw.write(text);
bw.close();
//InputFile created

File fout= new File("output.html");
fout.createNewFile();
fw = new FileWriter(fout);
bw = new BufferedWriter(fw);

//Initiating the Formatted String
formatted = "<!DOCTYPE html><html lang='en'><head><title>Result TypedJS</title><meta charset='UTF-8'><meta name='viewport' content='width=device-width, initial-scale=1.0'>"
    +"<script src='https://ajax.googleapis.com/ajax/libs/jquery/3.1.0/jquery.min.js'></script>"
    +"<script src='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/js/bootstrap.min.js' integrity='sha384-Tc5IQib027qvyjSMfHjOMaLkfuWVxZxUPnCJA7l2mCWNIpG9mGCD8wGNIcPD7Txa' crossorigin='anonymous'></script>"
    +"<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap.min.css' integrity='sha384-BVYiiSIFeK1dGmJRAkycuHAHRg32OmUcww7on3RYdg4Va+PmSTsz/K68vbdEjh4u' crossorigin='anonymous'>"
    +"<link rel='stylesheet' href='https://maxcdn.bootstrapcdn.com/bootstrap/3.3.7/css/bootstrap-theme.min.css' integrity='sha384-rHyoN1iRsVXV4nD0JutlnGaslCJuC7uwjduW9SVrLvRYooPp2bWYgmgJQIXwl/Sp' crossorigin='anonymous'>"
    +"<link rel='stylesheet' type='text/css' href='./css/styling.css'>"
    +"<script type='text/javascript' asyncsrc='https://example.com/MathJax.js?config=MML_CHTML'></script>"
    +"<script rel='text/javascript' src='./js/typed.js'></script></head><body>";

formatted+="<div id='typed-strings'><p><math xmlns='http://www.w3.org/1998/Math/MathML'>";
//Writing to the File Using the HTML Conventions
//Check if function returns Formatted String
for(i=0;i<text.length();i++){
	if(text_mode == 1){
		if(text.charAt(i)=='#'){
			text_mode = 0;
			formatted+="</mtext>^200 ";
		}
		else formatted += text.charAt(i);
	}else{
		switch(text.charAt(i)){
			case '^':int start=getNumerator(formatted.length());
					power = 1;
					map.put("power",0);
					stack.add("power");
					//brackets = 0;
					/*i=getSuperScript(text,i);
					i--;
					formatted+="^200 ";*/
					String t = formatted.substring(0,start);
					//System.out.println("\nThe value of Start is POWER:"+start);
					t += "<msup><mrow>"+formatted.substring(start,formatted.length())+"</mrow><mrow>";
					formatted = t;
					if(text.charAt(i+1)!='('){
						formatted += text.charAt(i+1)+"^200 </mrow></msup>";
						stack.remove(stack.size()-1);
						power = 0 ;
						i++;
					}
					break;
			case '&':int index = text.substring(i).indexOf(";");
					//System.out.println("The index is "+(i+index)+" and Substring : "+text.substring(i, i+index+1));
					if(operators.contains(text.substring(i, i+index+1))){
						formatted+="<mo>"+text.substring(i, i+index+1)+"</mo>";
					}
					else if(symbols.contains(text.substring(i, i+index+1))){
						formatted+="<mn>"+text.substring(i, i+index+1)+"</mn>";
					}
					else if(vectors.contains(text.substring(i, i+index+1))){
						formatted+="<mover><mi>"+text.charAt(i-1)+"</mi><mo>"+text.substring(i, i+index+1)+"</mo></mover>";
					}
					i+=index;
					formatted+="^200 ";
					break;
			case '=':formatted+=" = ";
					break;
			case '/':int startIndex = getNumerator(formatted.length());
					stack.add("division");
					map.put("division",0);
					//brackets = 0;
					division = 1;
					String temp = formatted.substring(0,startIndex);
					System.out.println("\nThe value of StartIndex is :"+startIndex);
					temp += "<mfrac><mrow>"+formatted.substring(startIndex,formatted.length())+"</mrow><mrow>";
					formatted = temp;
					if(text.charAt(i+1)!='('){
						formatted += text.charAt(i+1)+"^200 </mrow></mfrac>";
						stack.remove(stack.size()-1);
						division = 0;
						i++;
					}
					break;
			case '#':text_mode = 1;
					formatted+="<mtext>";
					break;
			default:if(i!=text.length()-1 && text.charAt(i)=='\\' && text.charAt(i+1) == 'n'){
						formatted+="<br></math><math xmlns='http://www.w3.org/1998/Math/MathML'>";
						i++;
						continue;
					}
					if(i==text.length()-1 || text.charAt(i+1)!='&'){
						int code = text.codePointAt(i);
						//System.out.print(code+" ");
						if(unicodes.contains(code)){
							//Permutation and Combination
							if(code == 67 || code == 80){
								String field = text.substring(i+2,i+2+text.substring(i+2).indexOf(")"));
								String []params = field.split(",");
								char ch=(code == 67)?'C':'P';
								formatted+="<munderover><mo>"+ch+"</mo><mn>"+params[0].trim()+"</mn><mn>"+params[1].trim()+"</mn></munderover>";
								i=i+2+text.substring(i+2).indexOf(")");
								continue;
							}
							munderover=1;
							formatted+="<munderover><mo>" + text.charAt(i) + "</mo>";
							String field = text.substring(i+2,i+2+text.substring(i+2).indexOf(")"));
							String []params = field.split(",");
							formatted+="<mn>"+params[0].trim()+"</mn>";
							formatted+="<mn>"+params[1].trim()+"</mn></munderover>";
							i=i+2+text.substring(i+2).indexOf(")");
							//i=i+1;//Potential Region of error put this as one ) bracket was comming after the operator symbols
							munderover=0;
						}
						else if((division == 1 || power == 1 ) && (text.charAt(i)==')' || text.charAt(i)=='(')){
							//brackets = (text.charAt(i)==')')?brackets+1:brackets-1;
							if(division == 1){
								int brackets = map.get("division");
								brackets = (text.charAt(i)==')')?brackets+1:brackets-1;
								map.put("division",brackets);
							}
							if(power == 1){
								int brackets = map.get("power");
								brackets = (text.charAt(i)==')')?brackets+1:brackets-1;
								map.put("power",brackets);							
							}
							formatted+=text.charAt(i)+"^200 ";
							while(stack.size()!=0 && map.get(stack.get(stack.size()-1))==0){
								if(stack.get(stack.size()-1).equals("power")){
									formatted+="</mrow></msup>";
									power=0;
								}else{
									formatted+="</mrow></mfrac>";
									division=0;
								}
								stack.remove(stack.size()-1);
							}
						}else{
							formatted+=text.charAt(i)+"^200 ";
						}
					}
					else if(text.charAt(i+1) == '&'){
						int indx = text.substring(i+1).indexOf(";")+1;
						//System.out.println("The index is::"+indx+ "substring : "+text.substring(i+1,i+1+indx));
						String checker = text.substring(i+1,i+1+indx);
						if(!vectors.contains(checker))
							formatted+=text.charAt(i)+"^200 ";
					}
					
		}
	}
}
formatted+="</math></p></div><span id='typed'></span>";
formatted+="<script type='text/javascript'>document.addEventListener('DOMContentLoaded', function(){Typed.new('#typed', {stringsElement: document.getElementById('typed-strings')});});"+"</script>";
formatted+="</body></html>";
bw.write(formatted);
bw.close();
%>
<h1>Success : File Written</h1>
</body>
</html>

<!--  List of Problems 
	- In MAthML on tags specific to it can be used.No other tags are allowed.
	- Getting Invalid Markup Warning during the animations
	- # has to be Used for text #
	- for Summation , Product , Integral , Combination , Permuatation Arguments must be Given in Brackets
	- Sum,Prod,Integral , Combination ,  Permutation  ------  Sym( arg1, arg2)
	- One Convention states that '/' can only be used for division and only brackets which will not create problem are () 
-->