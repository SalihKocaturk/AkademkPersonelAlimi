import 'package:get_it/get_it.dart';
import 'package:proje1/domain/cubits/admin_cubit.dart';

import 'domain/cubits/manager_cubit.dart';

GetIt getIt = GetIt.instance;

void setupLocators() {
  getIt.registerSingleton(AdminCubit());
  getIt.registerSingleton(ManagerCubit());
}
