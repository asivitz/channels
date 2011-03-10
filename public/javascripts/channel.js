var waitMin = 5;
var waitMax = 45;
var waitReset = 10;
var waitTime = waitReset;

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
    return $('#message_list li:first');
}

function getOldestContainer()
{
    return $('#message_list li:last');
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
