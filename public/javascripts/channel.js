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
    $.ajax(
        {
            url:"/channels/get_updates/" + channelid + "?previous_check=" + last_checked,
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

function makeContainer(username, time)
{
    var row = $('<li class="message_row">' +
        '<div class="meta">' +
        '<p class="username">' + username + ':</p>' +
        '<p class="date">' + time + '</p>' +
        '</div>' +
        '<div class="message_content"></div>');
    return row;
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
	var postAreaHeight = 120;
	var headerHeight = 50;
	var messageListHeight = browserHeight - postAreaHeight - headerHeight;
	//console.log(browserHeight, messageListHeight);
	var cssHeight = messageListHeight+'px';
	var postAreaWidth = browserWidth - 220;
	$('#post_area').css('width', postAreaWidth+'px');
	$('#messages').css('height', cssHeight);
}

function messageScrollBottom() {
	$("#messages").animate({ scrollTop: $("#messages").attr("scrollHeight") });
	//console.log('test');
}