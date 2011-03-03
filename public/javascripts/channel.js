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
            url:"/channels/get_updates/" + channelid + "?last_read=" + currentnumber,
            cache: false,
            dataType: 'json',
            success: function(json)
            {
                for (var i = 0; i < json.length; i++)
                {
                    var msg = json[i];
                    addMessageToTable(msg['id'], msg['name'], msg['date'], msg['content']);
                }
            }
        }
        );
        return false;
}

function addMessageToTable(id, username, time, content)
{
    //see if we already have this message
    var existing = $('#message_' + id);
    if (existing.length > 0)
        return;

    //find the last poster. if the names are the same, don't show a new username
    var toprow = $('#message_list li:first');
    var lastPoster = toprow.find('p.username').html();

    namedisplay = username + ":";
    var newPost = '<p id="message_' + id + '">' + content + '</p>';

    var added = null;
    if (lastPoster == username + ":") {
        var ul = toprow.find('.message_content');
        $(newPost).appendTo(ul);
        added = $(newPost);
    } else {
        var row = $('<li class="message_row"><div class="meta"><p class=\"username\">' + namedisplay + '</p><p class=\"date\">' + time + '</p></div><div class=\"message_content\">' + newPost + '</div></li>');
        row.prependTo('#message_list');
        added = row;
    }
    added[0].style.color = '#347acb';
    added[0].style.opacity = 0;
    added.animate({opacity:1, color:'black' },300,null);
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
