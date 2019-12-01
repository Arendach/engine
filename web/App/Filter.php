<?php

namespace Web\App;

use Illuminate\Database\Eloquent\Builder;

class Filter
{
    /**
     * @var Request
     */
    protected $request;

    /**
     * @var Builder
     */
    protected $builder;

    /**
     * Filter constructor.
     * @param Request $request
     */
    public function __construct(Request $request)
    {
        $this->request = container(Request::class);
    }

    /**
     * @return Builder
     */
    public function apply(Builder $builder)
    {
        $this->builder = $builder;

        foreach ($this->request->toArray() as $field => $value)
            if (method_exists($this, $field))
                $this->{$field}($value);


        foreach (get_class_methods($this) as $method) {
            if (preg_match('/^default_/', $method)) {
                $field = str_replace('default_', '', $method);

                if (!$this->request->has($field))
                    $this->{$method}();
            }
        }

        return $this->builder;
    }
}