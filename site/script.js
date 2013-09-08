
function form_Validator(form)
{

  if (form.email.value == "")
  {
    alert("Please enter your email address.");
    form.name.focus();
        return (false);
     }

  if (form.message.value == "")
  {
    alert("Please enter your message.");
    form.message.focus();
    return (false);
  }
    if (form.inst_name.value == "")
  {
    alert("Please enter intitution name.");
    form.message.focus();
    return (false);
  }
      if (form.inst_lat.value == "")
  {
    alert("Please enter latitude.");
    form.message.focus();
    return (false);
  }
  
  return (true);
  }
  


CLOSED_IMAGE='images/bulletRed.png';
OPEN_IMAGE='images/bulletGreen.png';

/* makeCollapsible - makes a list have collapsible sublists
 * 
 * listElement - the element representing the list to make collapsible
 */
function makeCollapsible(listElement){

  // removed list item bullets and the sapce they occupy
  listElement.style.listStyle='none';
  listElement.style.marginLeft='0';
  listElement.style.paddingLeft='0';

  // loop over all child elements of the list
 var child=listElement.firstChild;
 // var child=listElement.lastChild;
  while (child!=null){

    // only process li elements (and not text elements)
    if (child.nodeType==1){

      // build a list of child ol and ul elements and hide them
      var list=new Array();
      var grandchild=child.firstChild;
      while (grandchild!=null){
        if (grandchild.tagName=='OL' || grandchild.tagName=='UL'){
          grandchild.style.display='none';
          list.push(grandchild);
        }
        grandchild=grandchild.nextSibling;
      }

      // add toggle buttons
      var node=document.createElement('img');
      node.setAttribute('src',CLOSED_IMAGE);
      node.setAttribute('class','collapsibleClosed');
      node.onclick=createToggleFunction(node,list);
      child.insertBefore(node,child.firstChild);

    }

    child=child.nextSibling;
  }

}

/* createToggleFunction - returns a function that toggles the sublist display
 * 
 * toggleElement  - the element representing the toggle gadget
 * sublistElement - an array of elements representing the sublists that should
 *                  be opened or closed when the toggle gadget is clicked
 */
function createToggleFunction(toggleElement,sublistElements){

  return function(){

    // toggle status of toggle gadget
    if (toggleElement.getAttribute('class')=='collapsibleClosed'){
      toggleElement.setAttribute('class','collapsibleOpen');
      toggleElement.setAttribute('src',OPEN_IMAGE);
    }else{
      toggleElement.setAttribute('class','collapsibleClosed');
      toggleElement.setAttribute('src',CLOSED_IMAGE);
    }

    // toggle display of sublists
    for (var i=0;i<sublistElements.length;i++){
      sublistElements[i].style.display=
          (sublistElements[i].style.display=='block')?'none':'block';
    }

  }

}
