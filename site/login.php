<?php session_start(); ?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=utf-8" />
<title>Dax Morrison - Curatorial Project</title>
<link rel="stylesheet" type="text/css" href="xSS.css" /> 
</head>
<body>
<div id="container">
<div id="header">
<br />
<H1>Dax Morrison<br /></H1>
<h3>Curatorial Data Visualisation Project</h3>
</div>

<div id="titleBar">
</div>
<div id="home">
<a href="index.html"><H3>Home</H3></a>
</div>


<?php
date_default_timezone_set('UTC');

$server = "localhost";
$username = "kevinma";
$password = "JXwG2QdQNQ";
$database = "kevinma_dax";

/*MYSQL DATABASE CONNECTION
--------------------------------------*/
// connect to database
$dbh = mysql_connect ($server, $username, $password) or die ('I cannot connect to the database because: ' . mysql_error());
mysql_select_db ($database);

$url = $_POST["url"];

$messageDate = date("Y-m-d");

if(!empty($_SESSION['LoggedIn']) && !empty($_SESSION['Username']))
{

	echo "You're already logged in!<br />";
	echo "UserName: ".$row['UserName']." Name: ".$row['Name']." session = ". $_SESSION['LoggedIn'];
}
elseif(!empty($_POST['username']))
{
	 $username = mysql_real_escape_string($_POST['username']);
   // $password = md5(mysql_real_escape_string($_POST['password']));
    
	 $checklogin = mysql_query("SELECT * FROM users WHERE Username = '".$username."'");
    
    if(mysql_num_rows($checklogin) >= 1)
    {
    	 $row = mysql_fetch_array($checklogin);
        $_SESSION['Username'] = $username;
		$_SESSION['LoggedIn'] = 1;
  		echo "<h1>Success</h1>";
		echo "UserName: ".$row['UserName']." Name: ".$row['Name']."<br />";
		echo "You will now redirected back";
		echo "<meta http-equiv='refresh' content='2;$url' />";
    }else{
		echo "<h1>Bad login!</h1>";
		echo "<meta http-equiv='refresh' content='2;$url' />";
	}
}

?>


<div id="titleBar">
</div>
<br />
<br />

</div><!--container-->
</body>
</html>