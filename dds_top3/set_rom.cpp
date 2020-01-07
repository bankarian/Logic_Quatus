#include <cstdio>
#include <cmath>

#define PI 3.141592
#define DEPTH 1024     /*数据深度，即存储单元的个数*/
#define WIDTH 8       /*存储单元的宽度*/

int main()
{
int i,temp;
float s;

    FILE *fp;
    fp = fopen("TestMif.mif","w");   /*文件名随意，但扩展名必须为.mif*/
if(NULL==fp)
        printf("Can not creat file!\r\n");
else
    {
        printf("File created successfully!\n");
/*
        *    生成文件头：注意不要忘了“;”
*/
        fprintf(fp,"DEPTH = %d;\n",DEPTH);
        fprintf(fp,"WIDTH = %d;\n",WIDTH);
        fprintf(fp,"ADDRESS_RADIX = HEX;\n");
        fprintf(fp,"DATA_RADIX = HEX;\n");
        fprintf(fp,"CONTENT\n");
        fprintf(fp,"BEGIN\n");

/*
        * 以十六进制输出地址和数据
*/
		for(i=0;i<DEPTH;i++)
	 	{
			/*周期为1024个点的正弦波*/
	        s = sin(PI*i/512);
			/*将-1～1之间的正弦波的值扩展到0-255之间*/
	        temp = (int)((s+1)*255/2);
			/*以十六进制输出地址和数据*/
	        fprintf(fp,"%x\t:\t%x;\n",i,temp);
	    }//end for

	    fprintf(fp,"END;\n");
	    fclose(fp);
    }
    return 0;
}
