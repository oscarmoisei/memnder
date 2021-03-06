import 'package:dioc/dioc.dart';
import 'package:memnder/application/entity/lazy.dart';

extension LazyInjection on Container{

  Lazy<T> getLazy<T>({String name = null, String creator = null, InjectMode mode = InjectMode.unspecified}){
    return Lazy<T>(instanceFactory: () => this.get<T>(name: name, creator: creator, mode: mode));
  }

  Lazy<T> createLazy<T>({String creator = null}){
    return Lazy<T>(instanceFactory: () => this.create<T>(creator: creator));
  }

}