// admin_state.dart (part of admin_cubit.dart)
part of '../cubits/admin_cubit.dart';

abstract class AdminState {}

class AdminInitial extends AdminState {}

class AdminLoading extends AdminState {}

class AdminLoaded extends AdminState {
  final List<Announcement> announcements;
  AdminLoaded(this.announcements);
}
