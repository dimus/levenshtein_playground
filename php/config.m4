PHP_ARG_ENABLE(mdl, whether to enable MDL support,
[ --enable-mdl   Enable MDL support])

if test "$PHP_MDL" = "yes"; then
  AC_DEFINE(HAVE_MDL, 1, [Whether you have MDL])
  PHP_NEW_EXTENSION(mdl, mdl.c, $ext_shared)
fi