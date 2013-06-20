exports.destroy = (req, res) ->
  
  Media.delete req.params.id, (error, result) ->
    
    return res.send status: 400 if error?
    
    return res.send status: 404 unless result.affectedRows
    
    res.send status: 200