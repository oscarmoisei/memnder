
import 'package:dioc/dioc.dart';
import 'package:flutter/material.dart' hide Container;
import 'package:memnder/application/assembly/assembly.dart';
import 'package:memnder/application/assembly/mapper/authentication_mapper_assemly.dart';
import 'package:memnder/application/assembly/mapper/registration_mapper_assembly.dart';
import 'package:memnder/application/assembly/module/account_assembly.dart';
import 'package:memnder/application/assembly/module/app_assembly.dart';
import 'package:memnder/application/assembly/module/authentication_assembly.dart';
import 'package:memnder/application/assembly/module/load_meme_assembly.dart';
import 'package:memnder/application/assembly/module/memes_assembly.dart';
import 'package:memnder/application/assembly/module/registration_assembly.dart';
import 'package:memnder/application/assembly/module/root_assembly.dart';
import 'package:memnder/application/assembly/provider/api_base_provider_assembly.dart';
import 'package:memnder/application/assembly/provider/memes_api_provider_assembly.dart';
import 'package:memnder/application/assembly/provider/secure_storage_provider_assembly.dart';
import 'package:memnder/application/assembly/service/authentication_service_assembly.dart';
import 'package:memnder/application/assembly/service/meme_service_assembly.dart';
import 'package:memnder/application/assembly/service/registration_service_assembly.dart';
import 'package:memnder/application/assembly/validator/authentication_validator.dart';
import 'package:memnder/application/assembly/validator/registration_validator_assembly.dart';

class Assembler{
  
  Map<String, ModuleAssembly> moduleAssemblies = {
    "/" : RootAssembly(),
    "/app" : AppAssembly(),
    "/authentication" : AuthenticationAssembly(),
    "/authentication/registration" : RegistrationAssembly(),
    "/app/memes" : MemesAssembly(),
    "/app/account" : AccountAssembly(),
    "/app/load_meme" : LoadMemeAssembly(),
  };

  List<Assembly> providers = [
    SecureStorageProviderAssembly(),
    ApiBaseProviderAssembly(),
    MemesApiProviderAssembly(),
  ];

  List<Assembly> services = [
    RegistrationServiceAssembly(),
    AuthenticationServiceAssembly(),
    MemeServiceAssembly(),
  ];

  List<Assembly> mappers = [
    RegistrationMapperAssemly(),
    AuthenticationMapperAssembly()
  ];


  List<Assembly> validators = [
    RegistrationValidatorAssembly(),
    AuthenticationValidatorAssembly()
  ];

  Container container;

  Map<String, Widget Function(BuildContext)> _routes;
  Map<String, Widget Function(BuildContext)> get routes{
    if (_routes == null){
      _routes = _generateRoutes();
    }
    return _routes;
  }

  Assembler(){
    _routes = _generateRoutes();
  }

  Map<String, Widget Function(BuildContext)> _generateRoutes(){

    container = Container();

    providers .forEach((value){
      value.assemble(container);
    });

    services.forEach((value){
      value.assemble(container);
    });

    mappers.forEach((value){
      value.assemble(container);
    });

    validators.forEach((value){
      value.assemble(container);
    });

    moduleAssemblies.forEach((key, value){
      value.assemble(container);
    });

    return moduleAssemblies.map((key, value){
      return MapEntry(key, (c) => value.getView(c, container));
    });
  }

  Future prepareNamed(String route){
    return moduleAssemblies[route].prepare(container);
  }

  void unloadNamed(String route){
    var assembly = moduleAssemblies[route];
    assembly?.unload(container);
  }

}