$(document).ready(function() {
  embededvideo = $(".embed-responsive-item")[0];
  if(embededvideo != undefined){
    videoUrl = embededvideo.getAttribute("src");
    videoUrl = videoUrl.includes("http") ? videoUrl : "http://"+videoUrl;
    video = getEmbedVideoCode(videoUrl);
    if(video == ""){
      video = "<a class='video-button btn btn-default' href='"+ videoUrl + "' target='_blank'>Video</a>";
    }
    $(".embed-responsive").html(video);
  }

  if( $.fn.bxSlider) {
    $('.thumb-slider ul').bxSlider({loop:false});
  }

  $('.thumb-slider').magnificPopup({
    delegate: 'li:not(.bx-clone)>a',
    type: 'image',
    tLoading: 'Loading image #%curr%...',
    mainClass: 'mfp-img-mobile',
    gallery: {
      enabled: true,
      navigateByImgClick: true,
      preload: [0,1] // Will preload 0 - before current, and 1 after the current image
    },
    image: {
      tError: '<a href="%url%">The image #%curr%</a> could not be loaded.'
    }
  });

  $(".uninstall_app, .install_app").on("click",function(){
    var button = $(this);
    button.prop("disabled",true);
    var appId = button.data("app-id");
    var modelId = button.data("model-id");
    var ownershiplId = button.data("ownership-id");
    var performAction = button.hasClass("btn-primary") ? 'install' : 'uninstall';
    var url;
    if(performAction === 'install'){
      url = '/app/' + appId + '/install';
      params={model_id: modelId}
    }
    else{
      url = '/app/' + appId + '/uninstall';
      params={model_id: modelId,ownership_id: ownershiplId}
    }
    $.ajax({
      type: "POST",
      url: url,
      data: params,
      success: function(data){
        if(data['success'] == true){
          if (performAction === 'install') {
            $(".install_app").removeClass('btn-primary install_app').addClass('btn-danger uninstall_app');
            $(".uninstall_app")[0].setAttribute("data-ownership-id",data.data.ownershipId)
            $(".uninstall_app").html("<i class='fa fa-times'></i> Uninstall App");
            toastr.success('App installed successfully');
          }else{
            $(".uninstall_app")[0].removeAttribute("data-ownership-id")
            $(".uninstall_app").removeClass('btn-danger uninstall_app').addClass('btn-primary install_app');
            $(".install_app").html("<i class='fa fa-check'></i> Get It Now");
            toastr.success('App uninstalled successfully');
          }
        }
        button.prop("disabled",false);
      }
    });
  })
});
