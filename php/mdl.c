#ifdef HAVE_CONFIG_H
#include "config.h"
#endif

#include "php.h"
#include "php_mdl.h"

static function_entry mdl_functions[] = {
    PHP_FE(distance_utf, NULL)
    {NULL, NULL, NULL}
};

zend_module_entry mdl_module_entry = {
#if ZEND_MODULE_API_NO >= 20010901
    STANDARD_MODULE_HEADER,
#endif
    PHP_MDL_EXTNAME,
    mdl_functions,
    NULL,
    NULL,
    NULL,
    NULL,
    NULL,
#if ZEND_MODULE_API_NO >= 20010901
    PHP_MDL_VERSION,
#endif
    STANDARD_MODULE_PROPERTIES
};

#ifdef COMPILE_DL_MDL
ZEND_GET_MODULE(mdl)
#endif

PHP_FUNCTION(distance_utf)
{
    RETURN_LONG(2, 1);
}