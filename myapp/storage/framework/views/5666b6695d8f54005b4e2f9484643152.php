<!doctype html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport"
          content="width=device-width, user-scalable=no, initial-scale=1.0, maximum-scale=1.0, minimum-scale=1.0">
    <meta http-equiv="X-UA-Compatible" content="ie=edge">
    <title><?php echo $__env->yieldContent('title'); ?></title>
    <link rel="stylesheet" href="<?php echo e(asset('/')); ?>css/bootstrap.css"/>
    <link rel="stylesheet" href="<?php echo e(asset('/')); ?>css/all.css"/>
</head>
<body>

<nav class="navbar navbar-expand-md navbar-dark bg-dark">
    <div class="container">
        <a href="<?php echo e(route('home')); ?>" class="navbar-brand">TODOAPP</a>
        <ul class="navbar-nav">
            <li><a href="<?php echo e(route('home')); ?>" class="nav-link">Home</a> </li>
            <li><a href="<?php echo e(route('task.manage')); ?>" class="nav-link">Manage Todo</a> </li>
        </ul>
    </div>
</nav>

<?php echo $__env->yieldContent('body'); ?>

<script src="<?php echo e(asset('/')); ?>js/bootstrap.bundle.js"></script>
<script src="<?php echo e(asset('/')); ?>js/jquery-3.6.0.js"></script>
<script src="<?php echo e(asset('/')); ?>js/all.js"></script>
</body>
</html>
<?php /**PATH /dojo/work/resources/views/master.blade.php ENDPATH**/ ?>