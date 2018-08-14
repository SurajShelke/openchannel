function getSearchedApps(category){
  var search_val = $('.filter_app_with_text').val();
  $.ajax({
    type: "GET",
    url: "/home/filter_apps",
    data: {search_val: search_val, category_filter: category},
    success: function(data){
      $(".searchLoader").hide();
      $('.home_app_list').html(data.filter_result);
    }
  });
}

$(document).ready(function() {
  var timer, value;
  $("a.category_filter, a.collection_filter").on("click",function(e){
    value = '';
    e.preventDefault();
    $('[data-category]').parent().removeClass('active');
    $(this).parent().addClass('active');
    $('.filter_app_with_text').val('');
    var category = $(this).data('category');
    getSearchedApps(category);
  });

  $('.filter_app_with_text').on('keyup', function() {
    clearTimeout(timer);
    var str = $(this).val();
    if (value != str) {
      timer = setTimeout(function() {
        $(".searchLoader").show();
        value = str;
        var category = $('.category_filtering li.active a').data('category');
        getSearchedApps(category);
      }, 500);
    }
  });
});

function validateWebsite(){
  var pattern = /https?:\/\/w{0,3}\w*?\.(\w*?\.)?\w{2,3}\S*|www\.(\w*?\.)?\w*?\.\w{2,3}\S*|(\w*?\.)?\w*?\.\w{2,3}[\/\?]\S*/;
  if($(".website_url").val() != "" && !pattern.test($(".website_url").val())){
    $(".website_url").prop('required', true);
    $('.show_website').removeClass("hide").addClass("show");
  }else{
    $('.show_website').removeClass("show").addClass("hide");
    $(".website_url").prop('required', false);
  }
}

function validateVideoUrl(){
  var pattern = /https?:\/\/w{0,3}\w*?\.(\w*?\.)?\w{2,3}\S*|www\.(\w*?\.)?\w*?\.\w{2,3}\S*|(\w*?\.)?\w*?\.\w{2,3}[\/\?]\S*/;
  if($(".video-url").val() != "" && !pattern.test($(".video-url").val())){
    $(".video-url").prop('required', true);
    $('.show_video').removeClass('hide').addClass("show");
  }else{
    $('.show_video').removeClass("show").addClass("hide");
    $(".video-url").prop('required', false);
  }
}


function finalValidation(){
  websiteUrl = $(".website_url").val();
  videoUrl = $(".video-url").val();
  var pattern =  /^(http[s]?:\/\/){0,1}(www\.){0,1}[a-zA-Z0-9\.\-]+\.[a-zA-Z]{2,5}[\.]{0,1}/;
  if((websiteUrl != "" && !pattern.test(websiteUrl)) || (videoUrl != "" && !pattern.test(videoUrl))){
    return false;
  }
  return true;
}
