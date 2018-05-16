using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Threading;
using System.Net.Sockets;
using System.Net;

namespace chat_client
{
    public partial class Form1 : Form
    {
        public Socket _socket;
        public AsyncCallback pfnCallBack;
        IAsyncResult result;
        bool _login = false;
        public delegate void UpdateRichEditCallback(string text);
        public delegate void setTimerEnable(bool enable); 

        public Form1()
        {
            InitializeComponent();
        }

        private void connect()
        {
            try
            {
                _socket = new Socket(AddressFamily.InterNetwork, SocketType.Stream, ProtocolType.Tcp);
                IPEndPoint endPoint = new IPEndPoint(IPAddress.Parse("127.0.0.1"), 6666);
                _socket.Connect(endPoint);
            }
            catch(Exception ex){
                ;
            }

        }

        private void login()
        {
            try
            {
                if (_socket.Connected)
                {
                    string msg = accountId.Text + name.Text;
                    // 用UTF8格式来将string信息转化成byte数组形式
                    if (_socket != null)
                    {
                        // 发送数据
                        byte[] cmd = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt16(10000)));
                        byte[] accountByte = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt32(accountId.Text)));
                        byte[] nameLength = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt16(System.Text.Encoding.ASCII.GetBytes(name.Text).Length)));
                        byte[] nameByte = System.Text.Encoding.ASCII.GetBytes(name.Text);

                        byte[] sendData = new byte[4 + accountByte.Length + nameLength.Length + nameByte.Length];
                        //byte[] sendData = new byte[8];
                        byte[] headLength = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt16(sendData.Length)));
                        headLength.CopyTo(sendData, 0);
                        cmd.CopyTo(sendData, headLength.Length);
                        accountByte.CopyTo(sendData, headLength.Length + cmd.Length);
                        nameLength.CopyTo(sendData, headLength.Length + cmd.Length + accountByte.Length);
                        nameByte.CopyTo(sendData, headLength.Length + cmd.Length + accountByte.Length + nameLength.Length);
                        string str = BitConverter.ToString(sendData);
                        _socket.Send(sendData);
                        // _socket.Send(new byte[] { 0x00, 0x0b,  0x27, 0x10,   0x00, 0x00, 0x00, 0x02, 0x00, 0x01, 0x01 });
                        accountId.Enabled = false;
                        name.Enabled = false;
                        button2.Enabled = false;
                        send.Enabled = true;
                        content.Enabled = true;
                    }
                    else
                    {
                        connect();
                    }
                }
                else
                {
                    button2.Enabled = true;
                    connect();
                    MessageBox.Show("服务器连接失败, 请重启程序");
                    
                }
            }
            catch (Exception se)
            {
                button2.Enabled = true;
                connect();
                MessageBox.Show(se.Message, "提示");
            }
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            accountId.Text = Convert.ToString(new Random().Next(1, 10000000));
            connect();
             if(_socket.Connected)
             {
                WaitForData();
             }
             else
             {
                 MessageBox.Show("连接失败, 127.0.0.1：6666连接失败");
             }
        }

        // 等待数据
        public void WaitForData()
        {
            try
            {
                if (pfnCallBack == null)
                {
                    // 当连接上的客户有写的操作的时候，调用回调函数
                    pfnCallBack = new AsyncCallback(OnDataReceived);
                }
                SocketPacket socketPacket = new SocketPacket();
                socketPacket.thisSocket = _socket;
                result = _socket.BeginReceive(socketPacket.dataBuffer, 0, socketPacket.dataBuffer.Length,
                 SocketFlags.None, pfnCallBack, socketPacket);
            }
            catch (SocketException se)
            {
                MessageBox.Show(se.Message, "提示");
            }
        }
        private void OnUpdateRichEdit(string msg)
        {
            richTextBox1.Text = richTextBox1.Text + msg;
        }

        private void onTimerEnable(bool enable)
        {
            timer1.Enabled = enable;
        }

        // 更新信息列表，该方法可由主线程或其他工作线程所调用
        private void AppendToRichEditControl(string msg)
        {
            // 测试看是哪个线程调用了该方法
            if (InvokeRequired)
            {
                object[] pList = { msg };
                richTextBox1.BeginInvoke(new UpdateRichEditCallback(OnUpdateRichEdit), pList);
            }
            else
            {
                // 创建该控件的主线程直接更新信息列表
                OnUpdateRichEdit(msg);
            }
        }

        // 接收数据
        public void OnDataReceived(IAsyncResult asyn)
        {
            try
            {
                SocketPacket theSockId = (SocketPacket)asyn.AsyncState;
                int iRx = theSockId.thisSocket.EndReceive(asyn);
                string msg = "";
                string name = "";
                //theSockId.dataBuffer
                byte[] headLength = theSockId.dataBuffer.Skip(0).Take(2).ToArray();
                byte[] dd = theSockId.dataBuffer.Skip(2).Take(2).ToArray();
                Int16 cmd = System.Net.IPAddress.NetworkToHostOrder(BitConverter.ToInt16(theSockId.dataBuffer.Skip(2).Take(2).ToArray(), 0));
                switch (cmd)
                {
                    case 10000: // 登录成功
                        {
                            _login = true;
                        }
                        break;
                    case 11001: // 收到广播消息
                        {
                            byte[] accountId = theSockId.dataBuffer.Skip(4).Take(4).ToArray();
                            Int16 accountNameSize = System.Net.IPAddress.NetworkToHostOrder(BitConverter.ToInt16(theSockId.dataBuffer.Skip(8).Take(2).ToArray(), 0));
                            byte[] AccountName = theSockId.dataBuffer.Skip(10).Take(accountNameSize).ToArray();
                            name = Encoding.ASCII.GetString(AccountName);
                            Int16 contentSize = System.Net.IPAddress.NetworkToHostOrder(BitConverter.ToInt16(theSockId.dataBuffer.Skip(10 + accountNameSize).Take(2).ToArray(), 0));
                            byte[] contentByte = theSockId.dataBuffer.Skip(10 + accountNameSize + 2).Take(contentSize).ToArray();
                            msg = Encoding.ASCII.GetString(contentByte);
                            AppendToRichEditControl(name + "：" + msg + "\r\n");
                        }
                        break;
                }
                // 等待数据
                WaitForData();
            }
            catch (ObjectDisposedException)
            {
                System.Diagnostics.Debugger.Log(0, "1", "\nOnDataReceived: Socket已经关闭!\n");
            }
            catch (SocketException se)
            {
                if (se.ErrorCode == 10054)
                {
                    string msg = "服务器" + "停止服务!" + "\n";
                    MessageBox.Show(msg, "提示");
                    _socket.Close();
                    _socket = null;
                    button2.Enabled = true;
                }
                else
                {
                    button2.Enabled = true;
                    MessageBox.Show(se.Message, "提示");
                }
            }
        }

        private void button2_Click(object sender, EventArgs e)
        {
            login();
        }

        private void send_Click(object sender, EventArgs e)
        {
            try
            {
                byte[] cmd = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt16(11001)));
                byte[] contentSize = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt16(System.Text.Encoding.ASCII.GetBytes(content.Text).Length)));
                byte[] contentByte = System.Text.Encoding.ASCII.GetBytes(content.Text);
                byte[] sendData = new byte[4 + contentSize.Length + contentByte.Length];
                //byte[] sendData = new byte[8];
                byte[] headLength = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt16(sendData.Length)));
                headLength.CopyTo(sendData, 0);
                cmd.CopyTo(sendData, headLength.Length);
                contentSize.CopyTo(sendData, headLength.Length + cmd.Length);
                contentByte.CopyTo(sendData, headLength.Length + cmd.Length + contentSize.Length);
                string str = BitConverter.ToString(sendData);
                _socket.Send(sendData);
                //_socket.Send(new byte[] { 0x00, 0x06, 0x2a, 0xf9, 0x01, 0x02 });
                accountId.Enabled = false;
                name.Enabled = false;
                button2.Enabled = false;
                send.Enabled = true;
                content.Enabled = true;
                content.Text = "";
            }
            catch (Exception ex)
            {
                login();
            }

        }

        private void timer1_Tick(object sender, EventArgs e)
        {
            return;
            // 心跳
            if (_socket.Connected && _login)
            {
                // 发送心跳包
                byte[] cmd = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt16(10006)));
                byte[] sendData = new byte[4];
                //byte[] sendData = new byte[8];
                byte[] headLength = BitConverter.GetBytes(System.Net.IPAddress.HostToNetworkOrder(Convert.ToInt16(sendData.Length)));
                headLength.CopyTo(sendData, 0);
                cmd.CopyTo(sendData, headLength.Length);
                string str = BitConverter.ToString(sendData);
                _socket.Send(sendData);
            }
            else
            {
                button2.Enabled = true;
                connect();
                if (accountId.Enabled == false) {
                    login();
                }
            }
        }
    }

    // 该类保存Socket以及发送给服务器的数据
    public class SocketPacket
    {
        public System.Net.Sockets.Socket thisSocket;
        public byte[] dataBuffer = new byte[1024]; // 发给服务器的数据
    }
}
