import 'package:flutter/material.dart';
import 'package:memnder/application/entity/meme_reaction.dart';
import 'package:memnder/application/model/meme_model.dart';
import 'package:memnder/application/model/service_response.dart';
import 'package:memnder/application/service/authentication_service.dart';
import 'package:memnder/application/service/meme_service.dart';

import 'memes_event.dart';
import 'memes_state.dart';
import 'package:bloc/bloc.dart';

class MemesBloc extends Bloc<MemesEvent, MemesState>{

  final AuthenticationServiceInterface authenticationService;
  final MemeServiceInterface memeService;

  MemesBloc(
    {
      @required this.authenticationService,
      @required this.memeService
    }
  ) {
    authenticationService.addListener(authListener);
    print("inited $this");
  }
  
  void authListener(){
    add(AuthenticationChanged(
      state: authenticationService.isAuthenticated
    ));
  }

  @override
  Future<void> close() {
    print("deinited $this");
    authenticationService.removeListener(authListener);
    return super.close();
  }

  Future _getMeme()async{
    var response = await memeService.getMeme();
    
    if (response is Success<MemeModel>){
      add(MemeLoaded(meme: response.value));
    } else if (response is Success<String>){
      add(MemeAlert(message: response.value));
    }else if (response is Error){
      add(MemeError(
        message: response.message
      ));
    }
  }

  Future _setMemeReaction(int memeId, MemeReaction reaction)async{
    var response = await memeService.setMemeReaction(memeId, reaction);
    if (response is Error){
       add(MemeError(
         message: response.message
       ));
    }
  }

  Future _onReactionSet(int memeId, MemeReaction reaction)async{
    await _setMemeReaction(memeId, reaction);
    await _getMeme();
  }

  MemesState get initialState => authenticationService.isAuthenticated ?
    Initial() : Unauthenticated();

  @override
  Stream<MemesState> mapEventToState(MemesEvent event) async* {
    if (event is MemeRequested){
      yield* _mapRequested(event);
    } else if (event is MemeReactionSet){
      yield* _mapMemeReactionSet(event);
    } else if (event is MemeLoaded){
      yield* _mapMemeLoaded(event);
    } else if (event is MemeError){
      yield* _mapMemeError(event);
    } else if (event is MemeAlert){
      yield* _mapMemeAlert(event);
    } else if (event is AuthenticationChanged){
      yield* _mapAuthenticationChanged(event);
    }
  }

  Stream<MemesState> _mapAuthenticationChanged(AuthenticationChanged event)async*{
    yield event.state ? Initial() : Unauthenticated();
  }

  Stream<MemesState> _mapMemeAlert(MemeAlert event)async*{
    yield ShowAlert(
      message: event.message
    );
  }

  Stream<MemesState> _mapMemeError(MemeError event)async*{
    yield ShowError(
      message: event.message
    );
  }

  Stream<MemesState> _mapMemeLoaded(MemeLoaded event)async*{
    yield ShowMeme(
      meme: event.meme
    );
  }

  Stream<MemesState> _mapMemeReactionSet(MemeReactionSet event)async*{
    yield Loading();
    _onReactionSet(event.meme.id, event.reaction);
  }

  Stream<MemesState> _mapRequested(MemeRequested event)async*{
    yield Loading();
    _getMeme();
  }

}
			