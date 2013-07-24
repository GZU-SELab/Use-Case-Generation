using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Diagnostics;
using System.IO;

namespace Test
{
    class CallProcess
    {

        static void Main(string[] args) {


            //设置运行的命令行文件问ping.exe文件，这个文件系统会自己找到
            //如果是其它exe文件，则有可能需要指定详细路径，如运行z3.exe
            ProcessStartInfo start = new ProcessStartInfo("D:/users/zhuhao/documents/visual studio 2010/Projects/Test/Test/bin/Debug/z3.exe");

            //z3.exe调用命令
            start.Arguments = "/smt2 test.txt";

            //不显示dos命令行窗口
            //start.CreateNoWindow = true;

            //是否将输入输出写入RedirectStandardInput\RedirectStandardOutput
            //如果 Process 将文本写入其标准流中，则通常会在控制台上显示该文本。
            //通过重定向 StandardOutput 流，可以操作或取消进程的输出。
            //例如，您可以筛选文本、用不同方式将其格式化，也可以将输出同时写入控制台和指定的日志文件中。
            start.RedirectStandardOutput = true;//
            start.RedirectStandardInput = true;//

            //是否指定操作系统外壳进程启动程序??
            start.UseShellExecute = false;

            //开始进程
            Process p = Process.Start(start);

            //截取输出流
            StreamReader reader = p.StandardOutput;

            //每次读取一行
            while (!reader.EndOfStream)
            {
                Console.WriteLine(reader.ReadLine());
            }



            //等待程序执行完退出进程
            p.WaitForExit();

            //关闭进程
            p.Close();

            //关闭流
            reader.Close();

        }

    }
}
