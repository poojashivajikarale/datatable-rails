Create new project with ruby version 2.7.2 and rails version 6.1.3.1

$ rails new datatables_demo



Install essential libraries via yarn i.e. jquery, bootstrap and datatables.


$ yarn add jquery bootstrap datatables.net-bs4   

datatables.net-bs4 is an extended module of datatables.net for bootstrap type styles.

Now set up environment.js.

 #config/webpack/environment.js 

const { environment } = require('@rails/webpacker') 

const webpack = require('webpack') 

environment.plugins.append('Provide',

             new webpack.ProvidePlugin({        

                $: 'jquery',        jQuery: 'jquery'})) 

module.exports = environment  


Import JQuery global and require DataTables in application.js.

// app/javascript/packs/application.js  

import Rails from "@rails/ujs"

import Turbolinks from "turbolinks"

import * as ActiveStorage from "@rails/activestorage"

import "channels" require('datatables.net-bs4') 

import $ from 'jquery';

global.$ = jQuery; 

Rails.start()

Turbolinks.start()

ActiveStorage.start()   


Import Bootstrap Css in application.scss.

/* app/assets/stylesheets/application.css */ 

*= require bootstrap

*= require_tree .

*= require_self


Now run the scaffold command for CRUD of customers

$ rails generate scaffold Customer first_name:string last_name:string 

Run the migration

$ rails db:migrate

Now go to https://github.com/jbox-web/ajax-datatables-rails to install ajax-datatables-rails gem. 

Add these lines to your application's Gemfile:

gem 'ajax-datatables-rails'


And then execute:

$ bundle install 

Run the following command to generate datatable file for Customer.

 $ rails generate datatable Customer 

This will generate a file named customer_datatable.rb in app/datatables. Open the file and customize in the functions

#app/datatables/customer_datatable.rb

class CustomerDatatable < AjaxDatatablesRails::ActiveRecord


  def view_columns

    # Declare strings in this format: ModelName.column_name

    # or in aliased_join_table.column_name format

    @view_columns ||= {

       id: { source: "Customer.id", cond: :eq },

       first_name: { source: "Customer.first_name", cond: :like },

       last_name: { source: "Customer.last_name", cond: :like }

    }

  end


  def data

    records.map do |record|

      {

        # example:

        # id: record.id,

        # name: record.name

        id: record.id,

        first_name: record.first_name,

        last_name: record.last_name

      }

    end

  end


  def get_raw_records

    # insert query here

    # User.all

    Customer.all

  end


end


Now create a customers.js file in app/javascript/packs/ And write below code.

//app/javascript/packs/customers.js

$(document).ready(function() {

  $('#customers-datatable').dataTable({

    "processing": true,

    "serverSide": true,

    "ajax": {

      "url": $('#customers-datatable').data('source')

    },

    "pagingType": "full_numbers",

    "columns": [

      {"data": "id"},

      {"data": "first_name"},

      {"data": "last_name"}

    ]

    // pagingType is optional, if you want full pagination controls.

    // Check dataTables documentation to learn more about

    // available options.

  });

});


Now open the app/views/customers/index.html.erb file of customers and write the below code.

<div class="container">

<table id="customers-datatable" class="table table-striped table-bordered" style="width: 1000px;" data-source="<%= customers_path(format: :json) %>">

  <thead>

    <tr>

      <th>ID</th>

      <th>First Name</th>

      <th>Last Name</th>

    </tr>

  </thead>

  <tbody>

  </tbody>

</table>

</div>


To load the datatable for customer, we have to add it’s javascript file into application.js file. So after adding customers.js file into application.js file, your application.js file should look like this –

// app/javascript/packs/application.js

import Rails from "@rails/ujs"

import Turbolinks from "turbolinks"

import * as ActiveStorage from "@rails/activestorage"

import "channels"


require('datatables.net-bs4')


import $ from 'jquery';

global.$ = jQuery;


//here we have added customers js file

require("packs/customers")


Rails.start()

Turbolinks.start()

ActiveStorage.start()


Set the controller to respond to JSON

#app/controller/customers_controller.rb

def index

  respond_to do |format|

    format.html

    format.json { render json: CustomerDatatable.new(params) }

  end

end



Now browse the customers#index page http://localhost:3000/customers .

  

Let’s enable coffeescript into rails 6


Run the command under your rails app directory.

rails webpacker:install:coffee


Move the app/javascript/packs/customers.js file to app/javascript/packs/customers.coffee file and

Convert your js code to coffescript code on http://js2.coffee/


Your coffeescript file should look like this

 #app/javascript/packs/customers.coffee

$ ->  $('#customers-datatable').dataTable   

            processing: true   

            serverSide: true   

            ajax:      url: $('#customers-datatable').data('source')   

            pagingType: 'full_numbers'   

            columns: [      {data: 'id'}      {data: 'first_name'}      {data: 'last_name'}    ] 


Browse the customers#index page again, you may see below error


Uncaught Error: Module build failed (from ./node_modules/coffee-loader/dist/cjs.js):

TypeError: this.getOptions is not a function

    at Object.loader (/home/iris/work/test_app/node_modules/coffee-loader/dist/index.js:21:24)

    coffee hello_coffee-e04d1cb8ff6efefe10dd.js:96

    Webpack 3

hello_coffee-e04d1cb8ff6efefe10dd.js:96:7

    coffee hello_coffee-e04d1cb8ff6efefe10dd.js:96

    Webpack 3



Resolve this error –

By downgrading coffee-loader to the version 1.0.1

Edit package.json and change the version from

"coffee-loader": "^2.0.0",

to

"coffee-loader": "1.0.1",

Then run yarn install --check-files to apply the change.


 And browse the link http://localhost:3000/customers You are done !!!
