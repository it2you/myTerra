<?php $__env->startSection('title'); ?>
    ManageTodoPage
<?php $__env->stopSection(); ?>

<?php $__env->startSection('body'); ?>
    <section class="py-5">
        <div class="container">
            <div class="row">
                <div class="col-md-12">
                    <div class="card">
                        <div class="card-header">
                            Manage Todo Info
                        </div>
                        <div class="card-body">
                            <h4 class="text-center"><?php echo e(Session::get('message')); ?></h4>
                            <table class="table table-bordered table-hover">
                                <thead>
                                <tr>
                                    <th>Tittle</th>
                                    <th>Description</th>


                                    <th>Status</th>
                                </tr>
                                </thead>
                                <tbody>
                                <?php $__currentLoopData = $todos; $__env->addLoop($__currentLoopData); foreach($__currentLoopData as $todo): $__env->incrementLoopIndices(); $loop = $__env->getLastLoop(); ?>
                                    <tr>
                                        <td><?php echo e($todo->title); ?></td>
                                        <td><?php echo e($todo->description); ?></td>


                                        <td>
                                            <?php if($todo -> completed == 1): ?>
                                                <a class="btn btn-sm btn-success">Completed</a>
                                            <?php else: ?>
                                                <a class="btn btn-sm btn-success" style="background-color: red" >InComplete</a>
                                            <?php endif; ?>
                                        </td>
                                        <td>
                                            <a href="<?php echo e(route('todo.edit', ['id' => $todo->id])); ?>" class="btn btn-success btn-sm">
                                                <i class="fa fa-edit"></i>
                                            </a>
                                            <a href="<?php echo e(route('todo.delete', ['id' => $todo->id])); ?>" class="btn btn-danger btn-sm" onclick="return confirm('Are you sure to delete this?')">
                                                <i class="fa fa-trash"></i>
                                            </a>
                                        </td>
                                    </tr>
                                <?php endforeach; $__env->popLoop(); $loop = $__env->getLastLoop(); ?>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </div>
            </div>
    </section>
<?php $__env->stopSection(); ?>



<?php echo $__env->make('master', array_diff_key(get_defined_vars(), ['__data' => 1, '__path' => 1]))->render(); ?><?php /**PATH /dojo/work/resources/views/task/manage.blade.php ENDPATH**/ ?>