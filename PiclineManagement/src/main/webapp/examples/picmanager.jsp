<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%
String path = request.getContextPath();
String basePath = request.getScheme()+"://"+request.getServerName()+":"+request.getServerPort()+path+"/";
%>
<!DOCTYPE html>
<html>
<head>
<title>图片防篡改</title>
<script src="../vendor/jquery-1.7.1.min.js" type="text/javascript"></script>
<script src="../vendor/jquery.hashchange.min.js" type="text/javascript"></script>
<script src="../lib/jquery.easytabs.min.js" type="text/javascript"></script>

<style>
/* Example Styles for Demo */
.etabs {
	margin: 0;
	padding: 0;
}

.tab {
	display: inline-block;
	zoom: 1;
	*display: inline;
	background: #eee;
	border: solid 1px #999;
	border-bottom: none;
	-moz-border-radius: 4px 4px 0 0;
	-webkit-border-radius: 4px 4px 0 0;
}

.tab a {
	font-size: 14px;
	line-height: 2em;
	display: block;
	padding: 0 10px;
	outline: none;
}

.tab a:hover {
	text-decoration: underline;
}

.tab.active {
	background: #fff;
	padding-top: 6px;
	position: relative;
	top: 1px;
	border-color: #666;
}

.tab a.active {
	font-weight: bold;
}

.tab-container .panel-container {
	background: #fff;
	border: solid #666 1px;
	padding: 10px;
	-moz-border-radius: 0 4px 4px 4px;
	-webkit-border-radius: 0 4px 4px 4px;
}

.panel-container {
	margin-bottom: 10px;
}
</style>

<script type="text/javascript">
    $(document).ready( function() {
      $('#tab-container').easytabs();
    });
  </script>
</head>
<body>

	<h2>
		<%if(session.isNew()){%>
		<%}else{%>
		<%=session.getAttribute("sucflag")%>
		<%}%>
		<%session.invalidate();%>
	</h2>

	<div id="tab-container" class='tab-container'>
		<ul class='etabs'>
			<li class='tab'><a href="#tabs1-html">图片二维码加密</a></li>
			<li class='tab'><a href="#tabs1-js">指纹验证</a></li>

		</ul>
		<div class='panel-container'>
			<div id="tabs1-html">
				<form id="myform" onsubmit="return checkform('file1','file2')"
					action="<%=request.getContextPath()%>/ServletPic" method="post">
					<input id="produce" name="hid" type="hidden" value="0">
					<p>
					<div id="localImag1">
						<img id="preview1" width="100px" height="100px" style="" />
					</div>
					请选择图片：<input id="file1" type="file" name="file1"
						onchange=setImagePreview('file1','localImag1','preview1');><br>
					<p>
					<div id="localImag2">
						<img id="preview2" width="100px" height="100px" style="" />
					</div>
					请选择logo图片： <input id="file2" type="file" name="file2"
						onchange="setImagePreview('file2','localImag2','preview2')">
					加密重数： <select id="sec1" name="sec1">
						<option>1</option>
						<option>2</option>
						<option>3</option>
						<option>4</option>
						<option>5</option>
					</select> <br />
					<br /> <input type="submit" value="生成并加密"> <br>
				</form>
			</div>
			<div id="tabs1-js">


				<form id="assureform" onsubmit="return checkform('file3','file4')"
					action="<%=request.getContextPath()%>/ServletPic" method="post">
					<input id="assure" type="hidden" name="hid" value="1">
					<p>
					<div id="localImag3">
						<img id="preview3" width="100px" height="100px" style="" />
					</div>
					请选择加密图片：<input id="file3" type="file" name="file3"
						accept="image/jpg" onchange=setImagePreview('file3','localImag3','preview3');><br>
					<p>
					<div id="localImag4">
						<img id="preview4" width="100px" height="100px" style="" />
					</div>
					请选择待验证图片： <input id="file4" type="file" name="file4"
						onchange="setImagePreview('file4','localImag4','preview4')">
					加密重数： <select id="sec2" name="sec2">
						<option>1</option>
						<option>2</option>
						<option>3</option>
						<option>4</option>
						<option>5</option>
					</select> <br />
					<br /> <input type="submit" value="验证真伪"> <br>
				</form>
					</div>
             	</div>
	</div>
	<script> 

     //检查表单
     function checkform(input1,input2)
      {
           var f=document.getElementById(input1);
       if((document.getElementById(input1).value=="")||(document.getElementById(input2).value=="" ) )
       {
          alert("请选择图片！");
          return false;
       }
        return true;
      }

	 
	 
	 //预览图
	function setImagePreview(file,localImag,preview) {
		
		 var filepath=document.getElementById(file).value;
		 filepath=filepath.substring(filepath.lastIndexOf('.')+1,filepath.length)
		 if(filepath != 'jpg')
		 {alert("只能上传JPG格式的图片")
			 document.getElementById(file).value="";
		 return;
		 }
		
		var docObj = document.getElementById(file);
		
		
		var imgObjPreview = document.getElementById(preview);
		if (docObj.files && docObj.files[0]) {
			//火狐下，直接设img属性 
			imgObjPreview.style.display = 'block';
			imgObjPreview.style.width = '100px';
			imgObjPreview.style.height = '100px';
			//imgObjPreview.src = docObj.files[0].getAsDataURL(); 
			//火狐7以上版本不能用上面的getAsDataURL()方式获取，需要一下方式 
			imgObjPreview.src = window.URL.createObjectURL(docObj.files[0]);
		} else {
			//IE下，使用滤镜 
			docObj.select();
			var imgSrc = document.selection.createRange().text;
			var localImagId = document.getElementById(localImag);
			//必须设置初始大小 
			localImagId.style.width = "250px";
			localImagId.style.height = "200px";
			//图片异常的捕捉，防止用户修改后缀来伪造图片 
			try {
				localImagId.style.filter = "progid:DXImageTransform.Microsoft.AlphaImageLoader(sizingMethod=scale)";
				localImagId.filters
						.item("DXImageTransform.Microsoft.AlphaImageLoader").src = imgSrc;
			} catch (e) {
				alert("您上传的图片格式不正确，请重新选择!");
				return false;
			} 
			imgObjPreview.style.display = 'none';
			document.selection.empty();
		}
		return true;
	}
</script>
</body>
</html>
