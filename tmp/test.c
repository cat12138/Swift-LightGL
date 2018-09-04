#include <stdio.h>
#include <libxml/parser.h>


int main()
{
xmlDockPtr doc;
doc = xmlParserFile('testFile.xml');
if(doc == NULL)
{
printf("not good\n");
}
else {
printf("good\n");
xmlFreeDock(doc);
}
printf("good\n");
return 0;
}
