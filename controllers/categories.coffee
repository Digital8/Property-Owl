# exports.delete  = (require '../behaviors/delete')  Category
# exports.edit    = (require '../behaviors/edit')    Category
# exports.index   = (require '../behaviors/index')   Category
exports.add     = (require '../behaviors/add')     Category
exports.create  = (require '../behaviors/create')  Category, redirect: '/affiliates'
exports.destroy = (require '../behaviors/destroy') Category, redirect: '/affiliates'
exports.update  = (require '../behaviors/update')  Category, redirect: '/affiliates'