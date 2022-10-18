/* Toggle between adding and removing the "responsive" class to topnav when the user clicks on the icon */
function myFunction() {
  var x = document.getElementById("myTopnav");
  if (x.className === "topnav") {
    x.className += " responsive";
  } else {
    x.className = "topnav";
  }
}

window.onload = (function(){
  let submit = document.getElementById("submit")
  console.log(submit)

  submit.addEventListener('click', function(event){
    console.log("Hit the click")
    console.log(event);
    event.preventDefault();
    event.stopPropagation();

let site_name = document.getElementById("site_name").value
console.log("Site Name Appears Here:", site_name)

let board_numbers = document.getElementById("board_numbers").value
console.log("Site Name Appears Here:", board_numbers)

let destination_uid = document.getElementById("destination_uid").value
console.log("Site Name Appears Here:", destination_uid)
  })
})
