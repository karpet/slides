/* Ext ux LiveGrid with Search::OpenSearch */
Ext.onReady(function(){

    var Logger = function() { console.log.apply( console, arguments ) };

    var myView = new Ext.ux.grid.livegrid.GridView({
        nearLimit : 100,
        loadMask  : {
            msg :  'Buffering. Please wait...'
        }
    });
    
    var store = new Ext.ux.grid.livegrid.Store({
        autoLoad : true,
        url      : 'http://localhost:5000',
        bufferSize : 300,
        restful    : true,
        autoLoad   : false,
        reader     : new Ext.ux.grid.livegrid.JsonReader({
            root            : 'results',
            //versionProperty : 'version',
            totalProperty   : 'total',
            id              : 'uri'
          },
          [
            {name: 'uri'},
            {name: 'title'},
            {name: 'summary'},
            {name: 'author'},
            {name: 'places'},
            {name: 'people'},
            {name: 'topics'},
            {name: 'orgs'},
            {name: 'mtime', type: 'date', dateFormat: 'timestamp'}
          ]
        ),
        baseParams: {p:20}
    });

    // Custom rendering Template for the View
    var resultTpl = new Ext.XTemplate(
        '<tpl for=".">',
        '<div class="search-item">',
            '<h4><span>{mtime:date("M j, Y")} {author}</span><br />',
            '<a href="http://nosuchplace.foo/{uri}" onclick="alert(&quot;demo only&quot;);return false">{title}</a>',
            '</h4>',
            '<div>Topics: {topics}</div>',
            '<div>People: {people}</div>',
            '<div>Places: {places}</div>',
            '<div>Orgs: {orgs}</div>',
            '<p>{summary}</p>',
        '</div></tpl>'
    );

    var livegrid = new Ext.ux.grid.livegrid.GridPanel({
        enableDragDrop : false,
        cm             : new Ext.grid.ColumnModel([
            new Ext.grid.RowNumberer({header : '#' }),
            {   header: "Result", 
                align : 'left',   
                width: 550, 
                sortable: true, 
                dataIndex: 'uri',
                xtype: 'templatecolumn',
                /*
                renderer: function(value, metaData, record, rowIndex, colIndex, store) {
                    Logger(value, metaData, record, rowIndex, colIndex, store);
                    return value;
                }
                */
                tpl: resultTpl
            }
        ]),
        loadMask       : {
            msg : 'Loading...'
        },
        title      : 'Demo Search::OpenSearch',
        height     : 600,
        stripeRows : true,
        width      : 600,
        store      : store,
        selModel : new Ext.ux.grid.livegrid.RowSelectionModel(),
        view     : myView,
        tbar: [
            'Search: ', ' ',
            new Ext.ux.form.SearchField({
                store: store,
                width:400
            }),
            new Ext.form.ComboBox({
                id: 'bool-picker',
                store: [['AND','AND'],['OR','OR']],
                value: 'AND',
                width: 50,
                selectOnFocus: true,
                triggerAction: 'all'
            })
        ],
        bbar     : new Ext.ux.grid.livegrid.Toolbar({
            view        : myView,
            displayInfo : true
        })
    });

    livegrid.render('search-panel');
});
