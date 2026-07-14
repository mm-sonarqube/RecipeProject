import 'package:equatable/equatable.dart';
import 'package:flutter/foundation.dart';
import '../../domain/entities/recipe.dart';

@immutable
abstract class RecipeListState extends Equatable {
  const RecipeListState();

  @override
  List<Object?> get props => [];
}

class RecipeListInitial extends RecipeListState {}

class RecipeListLoading extends RecipeListState {}

class RecipeListLoaded extends RecipeListState {
  final List<Recipe> recipes;

  const RecipeListLoaded({required this.recipes});

  @override
  List<Object?> get props => [recipes];
}

class RecipeListError extends RecipeListState {
  final String message;

  const RecipeListError({required this.message});

  @override
  List<Object?> get props => [message];
}
