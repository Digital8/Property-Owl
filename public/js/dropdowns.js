$(function() {
   var format = function format(adspace) {
     if (!adspace.id) return adspace.text;
     return "<img class='select2-glyph' src='/images/adspace_icons/" + adspace.id.toLowerCase() + ".png'/>" + adspace.text;
    }
    $(".select2").select2({
      formatResult: format,
      formatSelection: format
    });
});