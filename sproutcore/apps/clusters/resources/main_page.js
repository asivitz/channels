// ==========================================================================
// Project:   Clusters - mainPage
// Copyright: ©2011 My Company, Inc.
// ==========================================================================
/*globals Clusters */

// This page describes the main user interface for your application.  
Clusters.mainPage = SC.Page.design({

  // The main pane is made visible on screen as soon as your app is loaded.
  // Add childViews to this pane for views to display immediately on page 
  // load.
  mainPane: SC.MainPane.design({
    childViews: 'middleView topView bottomView'.w(),

    topView: SC.ToolbarView.design({
        layout: { top: 0, left: 0, right: 0, height: 36 },
        childViews: 'titleView'.w(),
        anchorLocation: SC.ANCHOR_TOP,

        titleView: SC.LabelView.design({
            layout: { centerY: 0, height: 24, left: 8, width: 200 },
            controlSize: SC.LARGE_CONTROL_SIZE,
            fontWeight: SC.BOLD_WEIGHT,
            value: 'Clusters'
            })
        }),

    middleView: SC.ScrollView.design({
        hasHorizontalScroller: NO,
        layout: { top: 36, bottom: 32, left: 0, right: 0 },
        backgroundColor: 'white',

        contentView: SC.ListView.design({
            layout: { top: 0, left: 0  },
            contentBinding: 'Clusters.messageController',
            exampleView: Clusters.MessageGroupView,
            rowHeight: 100,
            rowSpacing: 10

            })
        }),

    bottomView: SC.ToolbarView.design({
        layout: { bottom: 0, left: 0, right: 0, height: 32 },
        anchorLocation: SC.ANCHOR_BOTTOM,
        childViews: 'labelView inputView'.w(),

        inputView: SC.TextFieldView.design({
            layout: { left:100, width:600 },
            hint: 'type your message here',
            keyDown: function(evt) {
                sc_super(); // necessary to guarantee regular handling of keyDown events, 
                if (evt.keyCode === 13) {
                    Clusters.messageController.addMessage('Axis', this.value);
                    return YES;
                    } else {
                    return NO;
                    }
                }
            }),

        labelView: SC.LabelView.design({
            layout: { left: 30 },
            fontWeight: SC.BOLD_WEIGHT,
            value: 'Type here'
            })
        })
    
  })

});
