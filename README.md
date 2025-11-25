# APIGOAT
 A RESTful API contains OWASP TOP 10 2023 vulnerabilities
 Developed by OWASP Bursa Technical University Student Chapter

 A deliberately vulnerable RESTful API project designed to demonstrate and practice the OWASP Top 10 (2023) security risks. Built with Node.js, Express.js, and MongoDB, APIGOAT provides a hands-on environment for security testing, exploit demonstrations, and defensive strategy development.

 it uses nodeJS runtime enviorment, ExpressJS Framework and mongoose ORM with mongoDB database.

![2023](https://github.com/OWASP-BURSA-TECHNICAL-UNIVERSITY/APIGOAT/assets/77548038/c3ce96e5-9dac-4d95-ae1e-6a48456fe141)

## Getting Started

These instructions will get you a copy of the project up and running on your local machine for development and testing purposes. See deployment for notes on how to deploy the project on a live system.

![resim](https://github.com/user-attachments/assets/9d08f073-9c29-4cce-a466-5baf3fa723ff)


### Prerequisites

Basically, this project needs nodejs working environment and a mongodb database service. you can also use mongodb atlas cloud database service. Other dependincies are managed by npm package manager.

### Installing

A step by step series of examples that tell you how to get a development env running

After cloning the project, you first need to edit the config.env file.
```
mongoDBURL = <mongodb atlas url>
OPENWEATHER_API_KEY=<open_weather_api_key>
```

Enter the string used to connect to the database you opened on the mongodb atlas and the key you got for free from the openweather api service here.

You can run the application by running the appropriate start file (ps1 for windows, sh for linux) according to your system (windows/linux).

## Built With

* [nodejs](https://nodejs.org/en/download/package-manager) - The runtime enviorment
* [mongodb](https://www.mongodb.com/atlas) - The database service
* [expressjs](https://expressjs.com/) - The nodeJS framework

## Contributing

This project is open for any process for submitting pull requests to us.


## Authors

* **Yusuf Talha ARABACI** - *Cyber Security Engineer* - [yusufarbc](https://github.com/yusufarbc)

## License

This project is licensed under the GNU General Public License (GPL) License
