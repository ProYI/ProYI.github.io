---
title: 前后端分离项目配置HTTPS
tags:
  - Nginx
  - Https
categories:
  - 技术
  - Java
  - Java web
abbrlink: cd624485
date: 2019-03-05 00:10:09
permalink:
description:
image:
copyright:
sticky:
---
<p class="description">使用云服务商提供的SSL证书，将网站域名访问从Http协议配置成Https，降低web访问风险，提高安全性</p>
<!-- more -->

## 前言
现在公司官网上线两三个月了，之前一直没理默认使用Http协议在chrome浏览器中提示不安全的问题。最近领导看到后，表示这个提示对用户来说不友好，会给用户一种我们网站不安全的信号，研究一下怎么去掉这个提示。  

经常关注互联网新闻的都知道前几年的心脏流血漏洞，从那起web方面的各种网络安全漏洞就越来越频繁并且明显的暴露出来。所以各大浏览器厂商也倾向于督促各个网站服务提供者将网站从Http升级到更加安全的Https协议，所以在chrome、Firefox等浏览器中访问Http网页，浏览器会提示不安全的连接，容易受到攻击。  

从web发展的趋势来看，Https升级是必然趋势。Google、百度等搜索引擎明确表示Https网站在同等条件下，相较于传统的Http网站会有更高的权重展示，排名更加靠前；Web功能日益强大的情况下，需要承载更加重要的业务，更高级别的安全保障也是必须进行的。 

自己做demo的时候，主要精力都在后端功能的实现，还真没配置过Https是如何实现的，刚好研究研究！  
## Https配置准备
Https配置主要实现就是由一个公认的第三方机构来签发证书，客户端访问时下载公钥，服务端存在私钥，web交互过程中使用证书来对会话进行加密，防止中间人攻击。  

我们可以使用OpenSSL来自行签发证书，但是自行签发的证书在互联网中其他服务商并不认识，所以这个证书的效力就很有限，所以才会出现商业上大型的证书签发机构。这些机构签发的证书是受到主流浏览器厂商认可的，具有较高的安全性。  

现在国内主流的域名提供商都会提供免费证书，当然如果要实现更高阶的证书还是费用昂贵。所以下载域名服务商提供的免费SSL证书，不同的web服务器有不同的后缀，比如我们前端使用的是Nginx作为页面服务器，所以使用的是`XXX_Nginx.crt`文件，同时还有一个对应的`XXX_Nginx.key`文件  

## 部署过程
项目结构是前端页面放置在Nginx下，同时Nginx监听80端口，进行接口访问时，请将求转发至8080端口的后端Tomcat服务器，比较简单的前后端分离  
由于是由Nginx进行控制访问的，所以直接将正式部署在Nginx服务器中  
1. 在Nginx安装目录中新建`cert`文件夹，将证书及密钥文件拷贝进去（其实在服务器任何地方都可以，只要之后Nginx配置文件能找到就行）  
2. 修改Nginx配置文件 `Nginx/conf/nginx.conf`  
    修改前，Nginx是监听Http的默认端口：80端口，然后静态资源直接访问Nginx下的静态页面，接口转发至8080  
    修改后，我们需要监听Https的默认端口：443端口，实现之前80端口的所有代理效果，同时监听80端口，并将所有80端口访问均转发至443端口完成工作  
    这样就可以实现即使用户在访问网站地址时输入[Http://xxx.xxx.com]()也会自动转换成[Https://xxx.xxx.com]()

    ```conf
    ...

    http {
        include       mime.types;
        default_type  application/octet-stream;

        sendfile        on;
        keepalive_timeout  50;

        server {
            listen       80;
            server_name  xxx.xxx.com;
            rewrite ^/(.*) https://$server_name$request_uri? permanent;
        }

        server {
            listen       443;
            server_name  xxx.xxx.com;

            ssl on;
            ssl_certificate   cert/www.xxx.xxx.crt;(刚刚的证书地址)
            ssl_certificate_key  cert/www.xxx.xxx.key;(刚刚的key地址)
            ssl_session_timeout 5m;
            ssl_ciphers ECDHE-RSA-AES128-GCM-SHA256:ECDHE:ECDH:AES:HIGH:!NULL:!aNULL:!MD5:!ADH:!RC4;
            ssl_protocols TLSv1 TLSv1.1 TLSv1.2;
            ssl_prefer_server_ciphers on;

            location / {
                root   html;
                index  index.html index.htm;
            }

            location /login {
                proxy_pass   http://localhost:8080;
            }


            error_page   500 502 503 504  /50x.html;
            location = /50x.html {
                root   html;
            }
        }
    }
    ```
3. 重启Nginx服务  
    ```
    由于本地是Windows版本  
    CMD命令行中的命令：  
    start nginx  启动Nginx服务  
    nginx -s quit 关闭Nginx服务
    ```
4. 浏览器访问对应的域名，浏览器显示`小锁头`图标，同时域名前改变为`https`  
    有可能需要清理浏览器缓存后才能显示成功  
至此，使用Nginx配置Https完成  

## 后记  
此文仅仅记录一下自己的配置过程，对于Https的认知非常浅薄，之后还需要继续加深Https的学习。  

Https并非是Http的完美升级，只是改进，并且有研究表明Https在Http三次握手的基础上加上通讯加密及解密过程，所以速度相较于http是有所下降的，但是安全性大大提高，所以Https并非是完美的，只能说是现阶段相对较为理想的一种web通信方式。  

如有错误，敬请告知，会及时修改，谢谢！
<hr />