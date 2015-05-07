$(function() {
  var imageDropzone;
  imageDropzone = new Dropzone("#image-dropzone");
  return imageDropzone.on("success", function(file, responseText) {
    var _this = this;
    appendContent(responseText.file_name.url, responseText.file_name);
    setTimeout(function(){
      _this.removeAllFiles();
    },1000);
  });
});

//TODO: Fix imageName
var appendContent = function(imageUrl, imageName) {
  $("#image-contents").append('<div class="col-md-6 col-lg-6">' + 
  '<div class="thumbnail"><img src="' + imageUrl + '"/>' +
  '<div class="caption">' +
  "![alternate-name]" + "("+ imageUrl + ")" +
  '</div>' +
  '</div></div>');
};

Dropzone.autoDiscover = false;
