import 'package:get_it/get_it.dart';
import 'package:proje1/domain/cubits/admin_cubit.dart';
import 'package:proje1/domain/cubits/auth_cubit.dart';
import 'package:proje1/domain/cubits/candidate_cubit.dart';
import 'package:proje1/domain/cubits/juri_cubit.dart';

GetIt getIt = GetIt.instance;

void setupLocators() {
  getIt.registerSingleton(AdminCubit());
  getIt.registerSingleton(AuthCubit());
  getIt.registerSingleton(JuryCubit());
  getIt.registerSingleton(CandidateCubit());


}
