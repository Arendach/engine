<?php

namespace Web\App;

abstract class Entity {

    /**
     * @var array
     */
	private $args = [];

    /**
     * @param $key
     * @return bool|mixed
     */
	public function parentGet($key){
		return (isset($this->args[$key]) ? $this->args[$key] : false );
	}

    /**
     * @param $key
     * @param $value
     */
	public function parentSet($key, $value){
		$this->args[$key] = $value;
	}

    /**
     * @return array
     */
	public function parentGets(){
		return $this->args;
	}

    /**
     * @param $object
     * @param $method
     * @param array $args
     */
	public function callMethod($object, $method, $args = []){
		if(!is_object($object)){
			throw new Exception("need Instance!");
		}

		if(method_exists($object, $method)){
			throw new Exception("method not exist in object : {$object}");
		}

		call_user_func_array([$object, $method], $args);
	}

	protected function response_not_authorized ()
    {
        response(401,'Для продовження вам необхідно авторизуватись!');
    }

	protected function display_404()
    {
        http_status(404);
        include t_file('pages/error_404');
        exit;
    }

    protected function display_500($message = false)
    {
        http_status(500);
        include t_file('pages/error_500');
        exit;
    }

    protected function display_403($message = false)
    {
        http_status(403);
        include t_file('pages/error_403');
        exit;
    }

    protected function display_login()
    {
        http_status(401);
        include t_file('login');
        exit;
    }

    public function access_check($key)
    {
        if (cannot($key)) {
            if ($_SERVER['REQUEST_METHOD'] == 'POST')
                response(403, 'У вас немає доступу для даної дії!');
            else
                response(403);
        }
    }

    public function access_group_not_found()
    {
        if ($_SERVER['REQUEST_METHOD'] == 'POST')
            response(500, 'Не існуюча група доступу!');
        else
            $this->display_500('Не існуюча група доступу!');
    }
}

?>