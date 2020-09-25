<?php

/*
|--------------------------------------------------------------------------
| Web Routes
|--------------------------------------------------------------------------
|
| Here is where you can register web routes for your application. These
| routes are loaded by the RouteServiceProvider within a group which
| contains the "web" middleware group. Now create something great!
|
*/


Route::get('/','IndexController@index');

Route::get('/pergamino','IndexController@pergamino');

Route::get('/plataforma','IndexController@plataforma');

Route::get('/modelos','IndexController@modelos');

Route::get('/documentos-cientificos','IndexController@documentos');

Route::get('/memorias','IndexController@memorias');

//app
Route::get('/app-experoya','IndexController@ipsim');
Route::get('/app-stadnic','IndexController@stadistic');
Route::get('/app-mapas','IndexController@maps');
Route::get('/app-centro-de-datos','IndexController@data');
Route::get('/app-clri','IndexController@clrimodel');
Route::get('/app-optiroya','IndexController@optimizacion');
