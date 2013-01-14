module.exports = () ->
  $rows = $ '.categories tbody tr'
  
  for row in $rows
    $row = $ row
    
    id = $row.data 'id'
    
    $row.find('.delete').click (event) ->
      
      event.preventDefault()
      
      $.delete "/categories/#{id}", (res, body, xhr) ->
        
        if xhr.status is 200
          
          $row.fadeOut()
  
  $tbody = $ '.categories tbody'
  
  $tfoot = $ '.categories tfoot'
  
  $addTr = $ '<tr>'
  $addTr.appendTo $tfoot
  
  $addTd = $ '<td colspan="3">'
  
  $addTd.appendTo $addTr
  
  $addA = $ '<a href="#">'
  $addA.appendTo $addTd
  
  $addImg = $ '<img src="/images/add.png", alt="Add">'
  $addImg.appendTo $addA
  
  $addA.append ' Add'
  
  $addA.click (event) ->
    event.preventDefault()
    
    # alert 'add'
    
    $.post "/categories", {key: '', entity_type: 'affiliate'}, (body, res, xhr) ->
      
      console.log arguments...
      
      
      
      if xhr.status is 200
       
        $tr = $ """
        <tr data-id="#{id}">
          <td><input type="text" class="key"></td>
          
          <td class="actions">
            <a href="/admin/categories/1/edit" alt="edit property" class="edit">
              <img src="/images/edit.png" alt="Edit">
              Edit
            </a>
          </td>
          
          <td class="actions">
            <a href="/admin/categories/1/delete" alt="delete property" class="delete">
              <img src="/images/delete.png" alt="Delete">
              Delete
            </a>
          </td>
        </tr>
        """
        
        $tr.appendTo $tbody
  
  sync = ($trs) ->
    console.log 'syncing', $trs
    
    for tr in $trs
      $tr = $ tr
      
      id = $tr.data 'id'
      
      $input = $tr.find 'input'
      
      do ($input, id, $tr) ->
      
        $input.bind 'input', (event) ->
          
          # console.log 'change'
          
          $.patch "/categories/#{id}", key: $input.val()
  
  sync $ '.categories tbody tr'