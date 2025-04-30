// candidate_state.dart
part of '../cubits/candidate_cubit.dart';

class CandidateState {}

class CandidateInitial extends CandidateState {}

class CandidateLoading extends CandidateState {}

class CandidateLoaded extends CandidateState {
  final List<Announcement1> announcements;
  final List<Application> applications;

  CandidateLoaded({required this.announcements, required this.applications});
}
