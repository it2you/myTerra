#!/bin/bash
cd $myapp_dir
php artisan migrate
php artisan serve --host=0.0.0.0 --port 8000
