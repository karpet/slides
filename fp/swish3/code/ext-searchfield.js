// based on ExtJS examples/ux/SearchField.js

Ext.ns('Ext.ux.form');

Ext.ux.form.SearchField = Ext.extend(Ext.form.TwinTriggerField, {
    initComponent : function(){
        Ext.ux.form.SearchField.superclass.initComponent.call(this);
        this.on('specialkey', function(f, e){
            if(e.getKey() == e.ENTER){
                this.onTrigger2Click();
            }
        }, this);
    },

    validationEvent:false,
    validateOnBlur:false,
    trigger1Class:'x-form-clear-trigger',
    trigger2Class:'x-form-search-trigger',
    hideTrigger1:true,
    width:180,
    hasSearch : false,
    paramName : 'q',

    onTrigger1Click : function(){
        if(this.hasSearch){
            this.el.dom.value = '';
            this.store.removeAll();
            return;
        }
    },

    onTrigger2Click : function(){
        var v = this.getRawValue();
        if(v.length < 1){
            this.onTrigger1Click();
            return;
        }
        var bool = Ext.getCmp('bool-picker').getValue();
        var opts = {'o': 0, 'b':bool};
        this.store.baseParams = this.store.baseParams || {};
        this.store.baseParams[this.paramName] = v;
        this.store.reload({params:opts});
        this.hasSearch = true;
        this.triggers[0].show();
    }
});
