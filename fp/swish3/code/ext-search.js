// based on http://www.extjs.com/deploy/dev/examples/form/custom.js

Ext.onReady(function(){
    var ds = new Ext.data.Store({
        proxy: new Ext.data.ScriptTagProxy({
            url: 'http://localhost:5000'
        }),
        reader: new Ext.data.JsonReader({
            root: 'results',
            totalProperty: 'total',
            id: 'uri'
        }, [
            {name: 'uri'},
            {name: 'title'},
            {name: 'summary'},
            {name: 'author'},
            {name: 'places'},
            {name: 'people'},
            {name: 'topics'},
            {name: 'orgs'},
            {name: 'mtime', type: 'date', dateFormat: 'timestamp'}
        ]),

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

    var panel = new Ext.Panel({
        applyTo: 'search-panel',
        title:'OpenSearch Reuters Benchmark Corpus',
        height:400,
        autoScroll:true,

        items: new Ext.DataView({
            tpl: resultTpl,
            store: ds,
            itemSelector: 'div.search-item'
        }),

        tbar: [
            'Search: ', ' ',
            new Ext.ux.form.SearchField({
                store: ds,
                width:500
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

        bbar: new Ext.PagingToolbar({
            store: ds,
            pageSize: 20,
            displayInfo: true,
            displayMsg: 'Results {0} - {1} of {2}',
            emptyMsg: "No results to display"
        })
    });

});
