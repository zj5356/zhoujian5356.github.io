<?php 
namespace Admin\Controller;
use Think\Controller;
class LoginController extends Controller{
	//后台登陆页
	public function login(){
		if (IS_POST) {
			//表单提交
			$username = I('post.username');
			$password = I('post.password');
			$code = I('post.code');
			//验证码校验
			//实例化Verify类，调用check方法
			$verify = new \Think\Verify();
			$check = $verify ->check($code);
			if (!$check) {
				$this -> error('验证码错误');
			}
			//数据检测
			if (!$username || !$password) {
				//用户名 密码不能为空
				$this -> error('用户名密码不能为空');
			}
			//实例化模型  根据用户名查询用户表
			$user = D('Manager') -> where(['username' => $username]) -> find();
			if ($user && $user['password'] == encrypt_password($password)){
				//登陆成功
				//设置登录页面
				session('manager_info',$user);
				//跳转后台首页
				$this -> success("登陆成功",U('Admin/Index/index'));
			}else{
				//用户名或者密码错误
				$this -> error('用户名或者密码错误');
			}
		}else{
				//调用模板
				$this -> display();
		}
	}
	//完成后台登陆功能
	public function logout(){
		//销毁session
		session(null);
		//跳转到登陆页
		$this -> redirect("Admin/Login/login");
	}



	//验证码生成
	public function captcha(){
		//实例化验证码类Verify类
		$config = array(
			'length' => 4,//验证码位数
			'useCurve' => false,//是否画混交曲线
			'useNoise' => false,是否添加杂点
		);
		$verify = new \Think\Verify($config);
		//调用entry方法生成并输出验证码图片
		$verify -> entry();
	}
	public function ajaxlogin(){
		//表单提交
		$username = I('post.username');
		$password = I('post.password');
		$code = I('post.code');
		//验证码校验
		//实例化verify类  调用check方法
		$verify = new \Think\Verify();
		$check = $verify -> check($code);
		if (!$check) {
			$rerurn = array(
				'code' => 10001,
				'mag' => '验证码错误'
			);
			$this -> ajaxReturn($return);
		}
		//数据检测
		if (!$username || !$password){
			//用户名密码不能为空
			$return = array(
				'code' => 10002,
				'msg' => '用户名密码不能为空'
			);
			$this -> ajaxReturn($return);
		}
		//实例化模型   根据用户名查询用户表
		$user = D('Manager') -> where(['username' => $username]) -> find();
		if ($user && $user['password'] == encrypt_password($password) ){
			//登陆成功
			//设置登录标识
			session('manager_info',$user);
			//跳转后台首页
			$return = array(
				'code' => 10000,
				'msg' => '登陆成功'
			);
			$this -> ajaxReturn($return);
		}else{
			//用户名或者密码错误
			$return = array(
				'code' => 10003,
				'msg' => '用户名或者密码错误'
			);
			$this -> ajaxReturn($return);
		}
	}
}


 ?>
