			j$(document).ready( function() {
				
				// Show menu when #myDiv is clicked
				j$("#gin").contextMenu({
					menu: 'yourMenu'
				},
					function(action, el, pos) {
					alert('kkk');	
					alert(
						'Action: ' + action + '\n\n' +
						'Element ID: ' + j$(el).attr('id') + '\n\n' + 
						'X: ' + pos.x + '  Y: ' + pos.y + ' (relative to element)\n\n' + 
						'X: ' + pos.docX + '  Y: ' + pos.docY+ ' (relative to document)'
						);
				  new Ajax.Updater('options','/testing/update_options', {asynchronous:true, evalScripts:true})
					 // <script type="text/javascript">
           // <%= remote_function(:update => "", :url => { :action => :that }) %>
           //</script>
				});

				
				// Enable cut/copy
				j$("#enableItems").click( function() {
					j$('#myMenu').enableContextMenuItems('#cut,#copy');
					j$(this).attr('disabled', true);
					j$("#disableItems").attr('disabled', false);
				});				
				
			});
             
			
//<%= remote_function(:update => "", :url => { :action => :that }) %>
