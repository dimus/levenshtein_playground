#ifndef PHP_MDL_H
#define PHP_MDL_H 1

#define PHP_MDL_VERSION "0.5"
#define PHP_MDL_EXTNAME "mdl"

PHP_FUNCTION(distance_utf);

extern zend_module_entry mdl_module_entry;
#define phpext_mdl_ptr &mdl_module_entry

#endif