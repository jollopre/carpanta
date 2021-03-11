#!/bin/bash
# Downloads extra assets from primer CSS that cannot be automatically bundled (e.g. https://github.com/primer/css/issues/722)

mkdir -p fonts
cp node_modules/@primer/css/fonts/Inter-Bold.woff fonts
cp node_modules/@primer/css/fonts/Inter-Medium.woff fonts
cp node_modules/@primer/css/fonts/Inter-Regular.woff fonts

mkdir -p images/spinners
cd images/spinners
curl https://github.com/images/spinners/octocat-spinner-16px.gif -O
curl https://github.com/images/spinners/octocat-spinner-32.gif -O
curl https://github.com/images/spinners/octocat-spinner-32-EAF2F5.gif -O

cd ..

mkdir -p modules/ajax
cd modules/ajax
curl https://github.com/images/modules/ajax/success@2x.png -O
curl https://github.com/images/modules/ajax/error@2x.png -O
curl https://github.com/images/modules/ajax/success.png -O
curl https://github.com/images/modules/ajax/error.png -O

cd ../../..
