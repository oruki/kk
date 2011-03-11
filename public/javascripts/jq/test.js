
			j$(document).ready( function() {
				
				// Show menu when #myDiv is clicked
				j$("#xyz").contextMenu({
					menu: 'myMenu'
				},
					function(action, el, pos) {
				  <script type="text/javascript">
				  <%= remote_function,:url=>{:action=>'that'},:with=>"'name=' + encodeURIComponent('やま')" %>
          </script>
					;
					alert('book');	
					alert(
						'Action: ' + action + '\n\n' +
						'Element ID: ' + j$(el).attr('id') + '\n\n' + 
						'X: ' + pos.x + '  Y: ' + pos.y + ' (relative to element)\n\n' + 
						'X: ' + pos.docX + '  Y: ' + pos.docY+ ' (relative to document)'
						);
				});
				
				// Show menu when a list item is clicked
				j$("#myList UL LI").contextMenu({
					menu: 'myMenu'
				}, function(action, el, pos) {
					alert(
						'Action: ' + action + '\n\n' +
						'Element text: ' + j$(el).text() + '\n\n' + 
						'X: ' + pos.x + '  Y: ' + pos.y + ' (relative to element)\n\n' + 
						'X: ' + pos.docX + '  Y: ' + pos.docY+ ' (relative to document)'
						);
				});
				
				// Disable menus
				j$("#disableMenus").click( function() {
					j$('#myDiv, #myList UL LI').disableContextMenu();
					j$(this).attr('disabled', true);
					j$("#enableMenus").attr('disabled', false);
				});
				
				// Enable menus
				j$("#enableMenus").click( function() {
					j$('#myDiv, #myList UL LI').enableContextMenu();
					j$(this).attr('disabled', true);
					j$("#disableMenus").attr('disabled', false);
				});
				
				// Disable cut/copy
				j$("#disableItems").click( function() {
					j$('#myMenu').disableContextMenuItems('#cut,#copy');
					j$(this).attr('disabled', true);
					j$("#enableItems").attr('disabled', false);
				});
				
				// Enable cut/copy
				j$("#enableItems").click( function() {
					j$('#myMenu').enableContextMenuItems('#cut,#copy');
					j$(this).attr('disabled', true);
					j$("#disableItems").attr('disabled', false);
				});				
				
			});
