var waitMin = 5;
var waitMax = 45;
var waitReset = 10;
var waitTime = waitReset;

$(function() {
	$("#nav li").hover(dropDownsOver, dropDownsOut);
	$("#settings li").hover(dropDownsOver, dropDownsOut);
});

function waitForMsg(channelid)
{
    var newmsgs = getNewMessages(channelid);
    if (newmsgs)
    {
        waitTime -= 5;
        if (waitTime < waitMin)
            waitTime = waitMin;
        if (waitTime > waitReset)
            waitTime = waitReset;
    }
    else
    {
        waitTime += 5;
        if (waitTime > waitMax)
            waitTime = waitMax;
    }

    setTimeout('waitForMsg(' + channelid + ')', waitTime * 1000);
}

function getNewMessages(channelid)
{
    var branch_string = "";
    if (current_branch != null)
    {
        branch_string = "&branch_id=" + current_branch;
    }
    $.ajax(
        {
            url:"/channels/get_updates/" + channelid + "?previous_check=" + last_checked + branch_string,
            cache: false,
        }
        );
        return false;
}

function topPoster()
{
    var lastPoster = getLatestContainer().find('p.username').html();
    return lastPoster;
}

function bottomPoster()
{
    var lastPoster = getOldestContainer().find('p.username').html();
    return lastPoster;
}

function getLatestContainer()
{
    return $('#message_list li:last');
}

function getOldestContainer()
{
    return $('#message_list li:first');
}

function showOverlay() {
	$('#overlay').fadeIn(300);
	$('#overlay .overlay_bg').click(function() {
		$(this).parent().fadeOut(300);
	});
	$('#overlay .close_overlay, #overlay .add_user_submit').click(function() {
		$('#overlay').fadeOut(300);
		return false;
	});
}

function spinOn()
{
    $('#spinner').css('visibility','visible');
}

function spinOff()
{
    $('#spinner').css('visibility','hidden');
}

// Navigation Dropdowns
function dropDownsOver() {
	$(this).find(".sub").stop().css('top','22px');
	$(function() {
	   function calcSubWidth() {
	       rowWidth = 0;
	       //Calculate row
	       $(this).find("ul").each(function() {
	           rowWidth += $(this).width();
	       });
	   };
	}); 
}
function dropDownsOut(){
	$(this).find(".sub").stop().css('top','-9999px');
}

// Get Browser Window Size
var browserWidth,browserHeight;
function getBrowserSize() {
	if (self.innerHeight) // all except Explorer
	{
		browserWidth = self.innerWidth;
		browserHeight = self.innerHeight;
	}
	else if (document.documentElement && document.documentElement.clientHeight)
		// Explorer 6 Strict Mode
	{
		browserWidth = document.documentElement.clientWidth;
		browserHeight = document.documentElement.clientHeight;
	}
	else if (document.body) // other Explorers
	{
		browserWidth = document.body.clientWidth;
		browserHeight = document.body.clientHeight;
	}
}

function messageResizing() {
	getBrowserSize();
	var postAreaHeight = 80;
	var headerHeight = 90;
	var messageListHeight = browserHeight - postAreaHeight - headerHeight;
	//console.log(browserHeight, messageListHeight);
	var cssHeight = messageListHeight+'px';
	var postAreaWidth = browserWidth - 170;
	$('#post_area').css('width', postAreaWidth+'px');
	$('#post_area .input_wrapper, #msginput').css('width', postAreaWidth-32+'px');
	$('#messages').css('height', cssHeight);
}

function messageScrollBottom() {
	$("#messages").attr({ scrollTop: $("#messages").attr("scrollHeight") });
	//console.log('test');
}

function initNotice() {
	$('.notice').hide();
	$('.notice').slideDown(300);
	function hideNotice() {
		$('.notice').slideUp(300);
	}
	setTimeout(hideNotice, 3000);
}

function inputFocusState() {
	$('.input_wrapper').addClass('focused');
	$('#msginput').focus(function() {
		$('.input_wrapper').addClass('focused');
	});
	$('#msginput').keydown(function() {
		$('.input_wrapper label').hide();
	});	
	$('#msginput').blur(function() {
		$('.input_wrapper').removeClass('focused');
		if($(this).attr('value') == '') {
			$('.input_wrapper label').fadeIn(100);
		}
	});
}
