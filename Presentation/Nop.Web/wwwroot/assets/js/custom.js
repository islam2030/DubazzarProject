$(document).ready(function () {
    // start glabel
    $('select').niceSelect();


    $(".cart_title").click(function () {
        $(".cart_body").slideToggle();
    });

});


// upload user image

function readURL(input) {
    if (input.files && input.files[0]) {
        var reader = new FileReader();
        reader.onload = function (e) {
            $('#imagePreview').css('background-image', 'url(' + e.target.result + ')');
            $('#imagePreview').hide();
            $('#imagePreview').fadeIn(650);
        }
        reader.readAsDataURL(input.files[0]);
    }
}
$("#imageUpload").change(function () {
    readURL(this);
});


// upload image
$(function () {
    var upload_image = $('.upload_image'), inputFile = $('#file'), img, btn, txt = 'Browse', txtAfter = 'Browse another pic';

    if (!upload_image.find('#upload').length) {
        upload_image.find('.input').append('<input type="button" value="' + txt + '" id="upload">');
        btn = $('#upload');
        $(".prev_image").prepend('<img src="" class="hidden" alt="Uploaded file" id="uploadImg" width="100">');
        img = $('#uploadImg');
    }

    btn.on('click', function () {
        img.animate({ opacity: 0 }, 300);
        inputFile.click();
    });

    inputFile.on('change', function (e) {
        upload_image.find('label').html(inputFile.val());

        var i = 0;
        for (i; i < e.originalEvent.srcElement.files.length; i++) {
            var file = e.originalEvent.srcElement.files[i],
                reader = new FileReader();

            reader.onloadend = function () {
                img.attr('src', reader.result).animate({ opacity: 1 }, 700);
            }
            reader.readAsDataURL(file);
            img.removeClass('hidden');
        }

        btn.val(txtAfter);
    });
});